//
//  SignInWithAppleManager.swift
//  Yara
//
//  Created by Johnny Owayed on 28/11/2024.
//

import AuthenticationServices
import FirebaseAuth
import CryptoKit

class SignInWithAppleManager: NSObject, ASAuthorizationControllerDelegate {
    // Unhashed nonce for Firebase auth
    private var currentNonce: String?
    
    // Completion handler to be called after sign in
    private var completionHandler: ((Result<FirebaseAuth.User, Error>) -> Void)?
    private let userService = UserService()
    // Generate random nonce for authentication
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    // Hash the nonce using SHA256
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Start the sign in process
    func startSignInWithAppleFlow(completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        self.completionHandler = completion
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    // Handle the authorization result
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            completionHandler?(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch identity token"])))
            return
        }
        
        // Create Firebase credential
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )
        
        // Sign in to Firebase
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            if let error = error {
                self?.completionHandler?(.failure(error))
                return
            }
            
            self?.createFirestoreUser(authResult: authResult, appleIDCredential: appleIDCredential)
            
            if let user = authResult?.user {
                // Save user info if this is the first sign in
                if appleIDCredential.fullName != nil {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")"
                    changeRequest.commitChanges(completion: nil)
                }
                
                
                
                self?.completionHandler?(.success(user))
            }
        }
    }
    
    func createFirestoreUser(authResult:AuthDataResult?, appleIDCredential:ASAuthorizationAppleIDCredential) {
        guard let firebaseUser = authResult?.user else {
            self.completionHandler?(.failure(AuthError.noAuthUser))
            return
        }
        
        self.userService.createFirestoreUser(
            for: firebaseUser,
            authProvider: "apple",
            firstName: appleIDCredential.fullName?.givenName,
            lastName: appleIDCredential.fullName?.familyName,
            isNotificationsEnabled: true
        ) { result in
            switch result {
            case .success(let user):
                print(user)
//                self.completionHandler?(.success(user))
            case .failure(let error):
                print(error)
                self.completionHandler?(.failure(error))
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completionHandler?(.failure(error))
    }
}
