//
//  Utils.swift
//  Yara
//
//  Created by Johnny Owayed on 14/10/2024.
//

import Foundation
import SwiftMessages
import UIKit


class Utils {
    let shared = Utils()
    
//    static func getUser() -> User?{
//        let key = "CURRENT_USER"
//        if let retrievedCodableObject = UserDefaults.standard.codableObject(dataType: User.self, key: key) {
//            return retrievedCodableObject
//        } else {
//            return nil
//        }
//    }
//    
//    static func saveUser(user: User) {
//        let key = "CURRENT_USER"
//        UserDefaults.standard.setCodableObject(user, forKey: key)
//    }
    
    static func setIsLaunchedBefore(val:Bool) {
        UserDefaults.standard.set(val, forKey: "IS_FIRST_LAUNCH")
    }
    
    static func getLaunchedBefore() -> Bool{
        return UserDefaults.standard.bool(forKey: "IS_FIRST_LAUNCH")
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func showErrorBanner(message:String, title:String? = nil) {
        DispatchQueue.main.async {
            let errorMessageView = MessageView.viewFromNib(layout: .cardView)
            errorMessageView.configureTheme(.error)
            let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
            errorMessageView.configureContent(title: title ?? "", body: message, iconText: iconText)
            errorMessageView.button?.isHidden = true
            var errorConfig = SwiftMessages.defaultConfig
            errorConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            SwiftMessages.show(config: errorConfig, view: errorMessageView)
        }
    }
    
    static func saveToken(token:String) {
        let key = "USER_TOKEN"
        UserDefaults.standard.setValue(token, forKey: key)
    }
    
    static func getToken() -> String{
        let key = "USER_TOKEN"
        return UserDefaults.standard.string(forKey: key) ?? ""
    }
    
    static func removeToken() {
        UserDefaults.standard.removeObject(forKey: "USER_TOKEN")
    }
}


extension UserDefaults {
    func setCodableObject<T: Codable>(_ data: T?, forKey defaultName: String) {
        let encoded = try? JSONEncoder().encode(data)
        set(encoded, forKey: defaultName)
    }
    
    func codableObject<T : Codable>(dataType: T.Type, key: String) -> T? {
        guard let userDefaultData = data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: userDefaultData)
    }
}
