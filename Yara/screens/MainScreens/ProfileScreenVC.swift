//
//  ProfileScreenVC.swift
//  Yara
//
//  Created by Johnny Owayed on 16/10/2024.
//

import Firebase
import FirebaseAnalytics
import FirebaseAuth
import NVActivityIndicatorView
//import /*Segment*/
import SwiftMessages
import UIKit
import ViewAnimator
import AuthenticationServices
import CryptoKit

class ProfileScreenVC: UIViewController {
    
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var profileLabel: UILabel!
    @IBOutlet var settingsLabel: UILabel!
    @IBOutlet var liveChatLabel: UILabel!
    @IBOutlet var helpLabel: UILabel!
    @IBOutlet var privacyLabel: UILabel!
    @IBOutlet var termsLabel: UILabel!
    @IBOutlet var signoutLabel: UILabel!
    @IBOutlet var deleteLabel: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var lblEmail: UILabel!
    
    @IBOutlet weak var profileViewHeight: NSLayoutConstraint!
    @IBOutlet weak var itemHeight: NSLayoutConstraint!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userId: String = ""
    var userFullName: String = ""
    var userEmail: String = ""
    var errorMessage = ""
    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.itemHeight.constant = ScreenRatioHelper.adjustedHeight(50)
        self.profileViewHeight.constant = ScreenRatioHelper.adjustedHeight(80)
        profileImage.setRounded()
        setupInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userFullName = (try! LocalStorageManager().getLocalUser()?.firstName ?? "") + " " + (try! LocalStorageManager().getLocalUser()?.lastName ?? "")
        self.name.text = self.userFullName
        self.userId = Auth.auth().currentUser?.uid ?? ""
        self.userEmail = try! LocalStorageManager().getLocalUser()?.email ?? ""
        self.lblEmail.text = self.userEmail
        
        
        self.profileImage.image = UIImage(named: "image_placeholder")
    }
    
    private func setupInterface() {
        accountLabel.text = "account".localized
        profileLabel.text = "profile".localized
        name.text = "loading".localized
        lblEmail.text = "loading".localized
        settingsLabel.text = "settings".localized
        liveChatLabel.text = "live_chat".localized
        helpLabel.text = "help".localized
        privacyLabel.text = "privacy".localized
        termsLabel.text = "terms".localized
        signoutLabel.text = "sign_out".localized
        deleteLabel.text = "delete_account".localized
        setupFonts()
    }
    
    func setupFonts() {
//        profileLabel.font = CustomFont.boldFont(size: 22)
        accountLabel.font = CustomFont.semiBoldFont(size: 25)
        name.font = CustomFont.semiBoldFont(size: 23)
        lblEmail.font = CustomFont.semiBoldFont(size: 16)
        settingsLabel.font = CustomFont.semiBoldFont(size: 25)
        
        liveChatLabel.font = CustomFont.semiBoldFont(size: 22)
        helpLabel.font = CustomFont.semiBoldFont(size: 22)
        privacyLabel.font = CustomFont.semiBoldFont(size: 22)
        termsLabel.font = CustomFont.semiBoldFont(size: 22)
        signoutLabel.font = CustomFont.semiBoldFont(size: 22)
        deleteLabel.font = CustomFont.semiBoldFont(size: 22)
    }
    
    @IBAction func liveChatPressed(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "BottomUpViewController") as! BottomUpViewController
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
    }
    
//    @IBAction func shareAppPressed(_ sender: Any) {
//        let urlString = "https://www.simly.io"
//        let linkToShare = [urlString]
//        let activityController = UIActivityViewController(activityItems: linkToShare, applicationActivities: nil)
//        present(activityController, animated: true, completion: nil)
//    }
    
    @IBAction func helpPressed(_ sender: Any) {
        // Show Success Notif
//        guard let url = URL(string: "https://simly.io/help") else { return }
//        UIApplication.shared.open(url)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "BottomUpViewController") as! BottomUpViewController
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
    }
    
    @IBAction func privacyPressed(_ sender: Any) {
        // Show Success Notif
        guard let url = URL(string: "https://www.getyara.io/privacy") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func termsPressed(_ sender: Any) {
        // Show Success Notif
        guard let url = URL(string: "https://www.getyara.io/terms") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        showPopup(isSignout: true)
    }
    
    @IBAction func btnDeleteAccountPressed(_ sender: Any) {
        showPopup(isSignout: false)
    }
    
    func showPopup(isSignout:Bool) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "ModalPopupViewController") as! ModalPopupViewController
        vc.delegate = self
        vc.obj = isSignout
        DispatchQueue.main.async {
            vc.setupView(img: UIImage(named: "ic_sign_out_popup")!, title: isSignout ? "sign_out".localized : "delete_account".localized, detail: "about_to_ride".localized, buttonTitle: isSignout ? "sign_out".localized : "delete_account".localized)
        }
        
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
    }
}

extension ProfileScreenVC: ModalPopupViewDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func onDismissPressed() {
        
    }
    
    func onTapButtonPressed(object: Any?) {
        let isAppleLogin = UserDefaults.standard.bool(forKey: "isAppleLogin")
        if let isSignout = object as? Bool {
            isSignout ? signout() : isAppleLogin ? deleteCurrentUser() : deleteAccount()
        }
    }
    
    func signout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
                        
            userLoggedOut()
            LocalStorageManager().removeLocalUser()
            Utils.removeToken()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func deleteAccount() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if error != nil {
                // reauthenticate (could not find a way to get the error type but most of the time re-authentication error is thrown by firebase. So assuming the same error here)
                self.showCardAlertWith(title: "login_required".localized, body: "to_perform_this_action".localized) {
                    self.userLoggedOut()
                    LocalStorageManager().removeLocalUser()
                    Utils.removeToken()
                }
            } else {
            
                // delete account success
                self.userLoggedOut()
            }
        }
    }
    
    
    
    private func deleteCurrentUser() {
        showCardAlertWith(title: "login_required".localized, body: "to_perform_this_action".localized) { [self] in
            let nonce = randomNonceString()
            currentNonce = nonce
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential
        else {
            print("Unable to retrieve AppleIDCredential")
            return
        }
        
        guard let rawNonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        
        guard let appleAuthCode = appleIDCredential.authorizationCode else {
            print("Unable to fetch authorization code")
            return
        }
        
        guard let authCodeString = String(data: appleAuthCode, encoding: .utf8) else {
            print("Unable to serialize auth code string from data: \(appleAuthCode.debugDescription)")
            return
        }
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: rawNonce
        )
        // Reauthenticate current Apple user with fresh Apple credential.
        Auth.auth().currentUser?.reauthenticate(with: credential) { (authResult, error) in
            if error == nil {
                
                let user = Auth.auth().currentUser
                
                Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
                user?.delete(completion: { error in
                    if (error == nil) {
                        self.userLoggedOut()
                        LocalStorageManager().removeLocalUser()
                        Utils.removeToken()
                        
                        print()
                    }else {
                        self.showErrorMessage()
                    }
                })
            } else {
                self.showErrorMessage()
            }
        }
    }
    
    func showErrorMessage() {
        DispatchQueue.main.async {
            let errorMessageView = MessageView.viewFromNib(layout: .cardView)
            errorMessageView.configureTheme(.error)
            let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
            errorMessageView.configureContent(title: "", body: "unknown_error_message".localized, iconText: iconText)
            errorMessageView.button?.isHidden = true
            var errorConfig = SwiftMessages.defaultConfig
            errorConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            SwiftMessages.show(config: errorConfig, view: errorMessageView)
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
    
    func showCardAlertWith(title: String, body: String, buttonTitle: String? = "yes".localized, cancelButtonTitle: String? = "no".localized, buttonTapHandler: (()->Swift.Void)? = nil) {
        DispatchQueue.main.async {
            let view: CardAlertView! = try! SwiftMessages.viewFromNib(named: "CardAlertView") as! CardAlertView
            view.configureDropShadow()
            view.configureContent(title: title, body: body)
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            view.button?.setTitle(buttonTitle, for: .normal)
            view.buttonTapHandler = { button in
                
                SwiftMessages.hide(id: view.id)
                
                buttonTapHandler?()
            }
            
            if let cancelButtonTitle = cancelButtonTitle {
                view.cancelButton.setTitle(cancelButtonTitle, for: .normal)
            } else {
                view.cancelButton.isHidden = true
            }
            
            var config = SwiftMessages.Config()
            config.duration = SwiftMessages.Duration.forever
            config.presentationStyle = .center
            config.dimMode = .color(color: UIColor.white.withAlphaComponent(0.4), interactive: buttonTapHandler == nil)
            SwiftMessages.show(config: config, view: view)
        }
    }
}
