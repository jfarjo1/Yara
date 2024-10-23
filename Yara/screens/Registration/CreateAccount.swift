//
//  CreateAccount.swift
//  Yara
//
//  Created by Johnny Owayed on 16/10/2024.
//

//
//  CreateAccountViewController.swift
//  Simly
//

import Firebase
import FirebaseAnalytics
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import NVActivityIndicatorView
import OneSignalFramework
import SwiftMessages
import UIKit
//import Segment
//import TikTokBusinessSDK

class CreateAccountViewController: UIViewController {
    @IBOutlet var loadingIndicator: NVActivityIndicatorView!
    @IBOutlet var status: UILabel!
    @IBOutlet var simlyLogo: UIImageView!
    
    var errorTitle: String?
    var errorText: String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var firstName:String!
    var lastName:String?
    var userEmail:String!
    var areNotificationsEnabled:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status.text = "setting_up_ur_profile".localized
        simlyLogo.isHidden = true
        loadingIndicator.popIn()
        
        loadingIndicator.startAnimating()
        
        createAccountLocal()
        
        status.font = CustomFont.semiBoldFont(size: 18)
    }
    
    //TODO: User Defaults
    func createAccountLocal() {
        
        var userService = UserService()
        
        guard let user = Auth.auth().currentUser else {return}
        
        userService.createFirestoreUser(for: user, authProvider: "email", firstName: self.firstName, lastName: self.lastName, isNotificationsEnabled: false) { result in
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.loadingIndicator.popOut()
                    self.status.text = "welcome_to_simly".localized
                }
                DispatchQueue.main.async {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.simlyLogo.isHidden = false
                        self.simlyLogo.popIn()
                        self.toMain(index: 0)
                    }
                }
            case .failure(let error):
                
                userService.getUser(completion: { result in
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            self.loadingIndicator.popOut()
                            self.status.text = "welcome_to_simly".localized
                        }
                        DispatchQueue.main.async {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.simlyLogo.isHidden = false
                                self.simlyLogo.popIn()
                                self.toMain(index: 0)
                            }
                        }
                    case .failure(let error):
                        self.errorTitle = "error_create_account_other".localized
                        DispatchQueue.main.async {
                            self.showError()
                            if self.isModal {
                                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                            } else {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    }
                }
            )}
        }
    }
     
    func showError() {
        let errorV = MessageView.viewFromNib(layout: .cardView)
        errorV.configureTheme(.error)
        errorV.configureContent(title: errorTitle ?? "error_create_account".localized, body: errorText ?? "an_error_occured_support".localized)
        var infoConfig = SwiftMessages.defaultConfig
        errorV.button?.isHidden = true
        infoConfig.presentationStyle = .top
        infoConfig.duration = .forever
        
        SwiftMessages.show(config: infoConfig, view: errorV)
    }
}
