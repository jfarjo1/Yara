//
//  SigninEmailVC.swift
//  Simly
//

import FirebaseAnalytics
import FirebaseAuth
import SwiftMessages

import UIKit

class EnterEmail: UIViewController, UITextFieldDelegate {
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var nextBgView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var backBgView: UIView!
    @IBOutlet weak var backButtonImage: UIImageView!
    @IBOutlet weak var nextLabel: UILabel!
    
    var userEmail: String?
    var link: String?
    var isSignUp:Bool = false
    var isEditEmail:Bool = false
    var password:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isSignUp {
            setupInterfaceSignUp()
        } else {
            setupInterface()
        }
        
        backBgView.setRounded()
        nextBgView.popIn()
        
        emailTextField.delegate = self
        emailTextField.becomeFirstResponder()
    }
    
    private func setupInterface() {
        
        self.backButtonImage.image = UIImage(named: "back_arrow")
        
        emailLabel.text = isEditEmail ? "enter_your_new_email".localized : "enter_your_email".localized
        emailLabel.font = CustomFont.semiBoldFont(size: 33)
        addressLabel.text = isEditEmail ? "please_enter_your_new_email_address".localized : "please_enter_your_email_address".localized
        addressLabel.font = CustomFont.semiBoldFont(size: 18)
        emailTextField.placeholder = "email_placeholder".localized
        emailTextField.font = CustomFont.semiBoldFont(size: 29)
        nextLabel.text = "next".localized
        nextLabel.font = CustomFont.semiBoldFont(size: 22)
        
    }
    
    private func setupInterfaceSignUp() {
        
        self.backButtonImage.image = UIImage(named: "back_arrow")
        
        emailLabel.text = "whats_email".localized
        emailLabel.font = CustomFont.semiBoldFont(size: 33)
        
        addressLabel.text = "lets_create_an_account_with_email_address".localized
        addressLabel.font = CustomFont.semiBoldFont(size: 18)
        
        emailTextField.placeholder = "email_placeholder".localized
        emailTextField.font = CustomFont.semiBoldFont(size: 29)
        
        nextLabel.text = "next".localized
        nextLabel.font = CustomFont.semiBoldFont(size: 22)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        
        return true
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popWithFade()
    }
    
    @IBAction func saveUserEmail(_ sender: Any) {
        nextBgView.popIn()
        TapticEngine.impact.feedback(.medium)
        
        if emailTextField.text == "" {
            let warning = MessageView.viewFromNib(layout: .cardView)
            warning.configureTheme(.warning)
            let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
            warning.configureContent(title: "email_empty".localized, body: "please_make_sure_to_enter_email".localized, iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
            
        } else {
            view.endEditing(true)
            if isEditEmail {
//                updateEmail()
            }else {
                addEmail()
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func addEmail() {
        
        view.endEditing(true)
        
        let email = emailTextField.text ?? ""
        
        let isValidEmail = Utils.isValidEmail(email)
        if !isValidEmail {
            let warning = MessageView.viewFromNib(layout: .cardView)
            warning.configureTheme(.warning)
            let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
            warning.configureContent(title: "email_empty".localized, body: "please_enter_your_email_address".localized, iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
            
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "EnterPassword") as! EnterPassword
            
            vc.isSignUp = self.isSignUp
            vc.userEmail = email
            self.navigationController?.fadeTo(vc)
        }
    }
}
