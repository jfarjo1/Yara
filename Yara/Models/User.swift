import FirebaseAuth
import FirebaseFirestore
import Foundation

// MARK: - User Model
struct User: Codable {
    @DocumentID var id: String?
    let uid: String
    let email: String
    let authProvider: String
    let createdAt: Date
    var lastLoginAt: Date
    var firstName: String?
    var lastName: String?
    var isNotificationsEnabled: Bool
    var profileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case email
        case authProvider = "auth_provider"
        case createdAt = "created_at"
        case lastLoginAt = "last_login_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case isNotificationsEnabled = "is_notifications_enabled"
        case profileImageUrl = "profile_image_url"
    }
}

// MARK: - Error Types
enum AuthError: Error {
    case noAuthUser
    case firestoreError
    case userDecodingError
    case signOutError
    case localStorageError
    case encodingError
    case decodingError
    case invalidCredentials
    
    var errorMessage: String {
        switch self {
        case .noAuthUser:
            return "No authenticated user found"
        case .firestoreError:
            return "Database error occurred"
        case .userDecodingError:
            return "Error processing user data"
        case .signOutError:
            return "Error signing out"
        case .localStorageError:
            return "Error accessing local storage"
        case .encodingError:
            return "Error saving user data"
        case .decodingError:
            return "Error reading user data"
        case .invalidCredentials:
            return "Invalid email or password"
        }
    }
}

// MARK: - Local Storage Manager
class LocalStorageManager {
    private let userDefaults = UserDefaults.standard
    private let userKey = "current_user"
    
    func saveUser(_ user: User) throws {
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            userDefaults.set(userData, forKey: userKey)
        } catch {
            throw AuthError.encodingError
        }
    }
    
    func getLocalUser() throws -> User? {
        guard let userData = userDefaults.data(forKey: userKey) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(User.self, from: userData)
        } catch {
            throw AuthError.decodingError
        }
    }
    
    func removeLocalUser() {
        userDefaults.removeObject(forKey: userKey)
    }
}

// MARK: - User Service
class UserService {
    // MARK: - Properties
    private let db = Firestore.firestore()
    private let usersCollection = "users"
    private let localStorage = LocalStorageManager()
    
    var isUserSignedIn: Bool {
        var localUser = try! localStorage.getLocalUser()
        return localUser != nil
    }
    
    // MARK: - Authentication Methods
    
    // Sign In
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let authUser = authResult?.user else {
                completion(.failure(AuthError.noAuthUser))
                return
            }
            
            self.fetchUser(uid: authUser.uid, completion: completion)
        }
    }
    
    // Sign Out
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            localStorage.removeLocalUser()
            completion(.success(()))
        } catch {
            completion(.failure(AuthError.signOutError))
        }
    }
    
    // Create user with email/password
    func createUserWithEmail(
        email: String,
        password: String,
        firstName: String?,
        lastName: String?,
        isNotificationsEnabled: Bool = true,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let authUser = authResult?.user else {
                completion(.failure(AuthError.noAuthUser))
                return
            }
            
            self.createFirestoreUser(
                for: authUser,
                authProvider: "email",
                firstName: firstName,
                lastName: lastName,
                isNotificationsEnabled: isNotificationsEnabled,
                completion: completion
            )
        }
    }
    
    // MARK: - Firestore Methods
    
    // Create Firestore user
    func createFirestoreUser(
        for authUser: FirebaseAuth.User,
        authProvider: String,
        firstName: String?,
        lastName: String?,
        isNotificationsEnabled: Bool,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        let userRef = db.collection(usersCollection).document(authUser.uid)
        
        userRef.getDocument { snapshot, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if snapshot?.exists == true {
                userRef.updateData([
                    "last_login_at": Date()
                ]) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    self.fetchUser(uid: authUser.uid, completion: completion)
                }
            } else {
                let newUser = User(
                    uid: authUser.uid,
                    email: authUser.email ?? "",
                    authProvider: authProvider,
                    createdAt: Date(),
                    lastLoginAt: Date(),
                    firstName: firstName,
                    lastName: lastName,
                    isNotificationsEnabled: isNotificationsEnabled,
                    profileImageUrl: authUser.photoURL?.absoluteString
                )
                
                do {
                    try userRef.setData(from: newUser) { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        
                        self.fetchUser(uid: authUser.uid, completion: completion)
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - User Data Methods
    
    // Get user from both local and remote
    func getUser(preferLocal: Bool = true, completion: @escaping (Result<User?, Error>) -> Void) {
        if preferLocal {
            if let localUser = getLocalUser() {
                completion(.success(localUser))
                // Fetch remote in background
                fetchRemoteUser { _ in }
                return
            }
        }
        
        fetchRemoteUser(completion: completion)
    }
    
    // Get local user
    func getLocalUser() -> User? {
        do {
            return try localStorage.getLocalUser()
        } catch {
            print("Error getting local user: \(error)")
            return nil
        }
    }
    
    // Update notification preferences
    func updateNotificationPreferences(
        enabled: Bool,
        completion: @escaping (Error?) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(AuthError.noAuthUser)
            return
        }
        
        db.collection(usersCollection).document(uid).updateData([
            "is_notifications_enabled": enabled
        ], completion: completion)
    }
    
    // MARK: - Private Helper Methods
    
    private func fetchRemoteUser(completion: @escaping (Result<User?, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.success(nil))
            return
        }
        
        fetchUser(uid: uid, completion: { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        let userRef = db.collection(usersCollection).document(uid)
        
        userRef.getDocument { snapshot, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot,
                  let user = try? snapshot.data(as: User.self) else {
                completion(.failure(AuthError.userDecodingError))
                return
            }
            
            // Save user locally
            try? self.localStorage.saveUser(user)
            completion(.success(user))
        }
    }
}
