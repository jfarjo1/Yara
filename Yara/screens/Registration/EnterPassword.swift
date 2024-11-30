//
//  SignInPasswordViewController.swift
//  Simly
//

import FirebaseAnalytics
import FirebaseAuth
import SwiftMessages
import UIKit

class EnterPassword: UIViewController, UITextFieldDelegate {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var backBgView: UIView!
    @IBOutlet var nextBgView: UIView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet weak var backButtonImage: UIImageView!
    @IBOutlet var resetPasswordLabel: UILabel!
    @IBOutlet var resetPasswordView: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userEmail: String!
    var link: String?
    var isSignUp:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBgView.setRounded()
        nextBgView.popIn()
        
        if isSignUp {
            setupSignUpInterface()
        }else {
            setupSignInInterface()
        }
        
        nextBgView.layer.masksToBounds = true
        nextBgView.layer.cornerRadius = 13
        
        passwordTextField.delegate = self
        passwordTextField.becomeFirstResponder()
        
        passwordTextField.isSecureTextEntry = true
        
        if !isSignUp {
            resetPasswordLabel.isHidden = false
            _ = TapGestureRecognizer.addTapGesture(to: resetPasswordLabel, action: {
                self.resetPassword()
            })
        }else {
            resetPasswordLabel.isHidden = true
            resetPasswordView.isHidden = true
        }
        
    }
    
    func resetPassword() {
        let loader = showLoader()
        Auth.auth().sendPasswordReset(withEmail: self.userEmail ?? "") { error in
            DispatchQueue.main.async {
                self.hideLoader(loader: loader)
            }
            if let error = error {
                print("Error connecting to database")
                
                let errorV = MessageView.viewFromNib(layout: .cardView)
                errorV.configureTheme(.error)
                errorV.configureContent(title: "Error", body: "\(error.localizedDescription)")
                var infoConfig = SwiftMessages.defaultConfig
                errorV.button?.isHidden = true
                infoConfig.presentationStyle = .top
                infoConfig.duration = .automatic
                DispatchQueue.main.async {
                    
                    SwiftMessages.show(config: infoConfig, view: errorV)
                }
                
            } else {
                self.performSegue(withIdentifier: "ShowPopUp", sender: self)
            }
        }
    }
    
    private func setupSignInInterface() {
        
        self.backButtonImage.image = UIImage(named: "back_arrow")
        
        titleLabel.text = "Enter your password"
        titleLabel.font = CustomFont.semiBoldFont(size: 33)
        
        subtitleLabel.text = "Please enter your password"
        subtitleLabel.font = CustomFont.semiBoldFont(size: 18)
        
        passwordTextField.placeholder = "Password"
        passwordTextField.font = CustomFont.semiBoldFont(size: 29)
        
        loginLabel.text = "Login"
        loginLabel.font = CustomFont.semiBoldFont(size: 22)
        
        //        resetPasswordLabel.text = "reset_password_title".localized
        
        resetPasswordLabel.font = CustomFont.semiBoldFont(size: 10)
        createNoteLabelText()
    }
    
    private func setupSignUpInterface() {
        self.backButtonImage.image = UIImage(named: "back_arrow")
        
        titleLabel.text = "Choose a password"
        titleLabel.font = CustomFont.semiBoldFont(size: 33)
        
        subtitleLabel.text = "Create a secure password linked to your account"
        subtitleLabel.font = CustomFont.semiBoldFont(size: 18)
        
        passwordTextField.placeholder = "Password"
        passwordTextField.font = CustomFont.semiBoldFont(size: 29)
                
        loginLabel.text = "Next"
        loginLabel.font = CustomFont.semiBoldFont(size: 22)
    }
    
    func createNoteLabelText() {
        
        let attributedText = NSMutableAttributedString(string: "Password playing hide and seek?\nLet's find you a new one!")
        
        let spacingText = NSAttributedString(string: "\u{00a0}", attributes: [
            .font: CustomFont.boldFont(size: 10),
        ])
        
        attributedText.append(spacingText)
        
        let learnMoreLabel = PaddingLabel()
        learnMoreLabel.text = " \(("Reset it"))"
        learnMoreLabel.font = CustomFont.boldFont(size: 10)
        learnMoreLabel.textColor = UIColor(hex: "#999999")
        learnMoreLabel.sizeToFit()
        learnMoreLabel.padding(4, 4, 5, 5)
        
        learnMoreLabel.backgroundColor = UIColor(hex: "#F9FAFB")
        learnMoreLabel.layer.cornerRadius = learnMoreLabel.frame.height/2
        
        let learnMoreAttachment = NSTextAttachment()
        learnMoreAttachment.image = learnMoreLabel.imageWithView()
        
        let learnMoreAttributedString = NSAttributedString(attachment: learnMoreAttachment)
        
        attributedText.append(learnMoreAttributedString)
        attributedText.addAttribute(.baselineOffset, value: -7, range: NSRange(location: attributedText.length - learnMoreAttributedString.length, length: learnMoreAttributedString.length))
        
        resetPasswordLabel.attributedText = attributedText
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
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
    
    @IBAction func backPressed(_ sender: Any) {
        if (isModal) {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popWithFade()
        }
    }
    
    @IBAction func loginU(_ sender: Any) {
        nextBgView.popIn()
        TapticEngine.impact.feedback(.medium)
        
        if passwordTextField.text == "" {
            let warning = MessageView.viewFromNib(layout: .cardView)
            warning.configureTheme(.warning)
            let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
            warning.configureContent(title: "Password Empty", body: "Please make sure to enter your password.", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            DispatchQueue.main.async {
                
                SwiftMessages.show(config: warningConfig, view: warning)
            }
            
        } else {
             if isSignUp {
                view.endEditing(true)
                addPassword()
            }else {
                view.endEditing(true)
                login()
            }
        }
    }
    
    func changePassword() {
        let password = passwordTextField.text ?? ""
        
        if password == "" {
            let warning = MessageView.viewFromNib(layout: .cardView)
            warning.configureTheme(.warning)
            let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
            warning.configureContent(title: "Password Empty", body: "Please make sure to enter your password.", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            DispatchQueue.main.async {
                
                SwiftMessages.show(config: warningConfig, view: warning)
            }
            
        } else {
            Auth.auth().currentUser?.updatePassword(to: password) { (error) in
                if error == nil {
                    DispatchQueue.main.async {
//                        self.toMain(index: 0)
                    //TODO: Go To main
                    }
                } else {
                    let errorV = MessageView.viewFromNib(layout: .cardView)
                    errorV.configureTheme(.error)
                    errorV.configureContent(title: "Sign in Failure", body: error!.localizedDescription)
                    var infoConfig = SwiftMessages.defaultConfig
                    errorV.button?.isHidden = true
                    infoConfig.presentationStyle = .top
                    infoConfig.duration = .forever
                    DispatchQueue.main.async {
                        SwiftMessages.show(config: infoConfig, view: errorV)
                        
                    }
                }
            }
        }
    }
    
    func goToNewPassword() {
        
        view.endEditing(true)
        
        let password = passwordTextField.text ?? ""
        
        if password == "" {
            let warning = MessageView.viewFromNib(layout: .cardView)
            warning.configureTheme(.warning)
            let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
            warning.configureContent(title: "password_empty".localized, body: "please_make_sure_enter_password".localized, iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            DispatchQueue.main.async {
                
                SwiftMessages.show(config: warningConfig, view: warning)
            }
            
        } else {
            
            let credentials = EmailAuthProvider.credential(withEmail: try! LocalStorageManager().getLocalUser()?.email ?? "", password: password)
            Auth.auth().currentUser?.reauthenticate(with: credentials) { result,error  in
                if error == nil {
                    DispatchQueue.main.async {
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "EnterPassword") as! EnterPassword
                        vc.userEmail = try! LocalStorageManager().getLocalUser()?.email ?? ""
                        self.navigationController?.fadeTo(vc)
                    }
                } else {
                    if error!.localizedDescription.errorDescription == "The email address is already in use by another account." {
                        let errorV = MessageView.viewFromNib(layout: .cardView)
                        errorV.configureTheme(.error)
                        errorV.configureContent(title: "signin_failure".localized, body: error!.localizedDescription + "email_please_go_login_page".localized)
                        var infoConfig = SwiftMessages.defaultConfig
                        errorV.button?.isHidden = true
                        infoConfig.presentationStyle = .top
                        infoConfig.duration = .forever
                        DispatchQueue.main.async {
                            SwiftMessages.show(config: infoConfig, view: errorV)
                        }
                    } else {
                        let errorV = MessageView.viewFromNib(layout: .cardView)
                        errorV.configureTheme(.error)
                        errorV.configureContent(title: "signin_failure".localized, body: error!.localizedDescription)
                        var infoConfig = SwiftMessages.defaultConfig
                        errorV.button?.isHidden = true
                        infoConfig.presentationStyle = .top
                        infoConfig.duration = .forever
                        DispatchQueue.main.async {
                            SwiftMessages.show(config: infoConfig, view: errorV)
                        }
                    }
                }
            }
        }
    }
    
    func goToEmail() {
        
        view.endEditing(true)
        
        let password = passwordTextField.text ?? ""
        
        if password == "" {
            let warning = MessageView.viewFromNib(layout: .cardView)
            warning.configureTheme(.warning)
            let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
            warning.configureContent(title: "password_empty".localized, body: "please_make_sure_enter_password".localized, iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            DispatchQueue.main.async {
                SwiftMessages.show(config: warningConfig, view: warning)
            }
        } else {
            let credentials = EmailAuthProvider.credential(withEmail: try! LocalStorageManager().getLocalUser()?.email ?? "", password: password)
            Auth.auth().currentUser?.reauthenticate(with: credentials) { result,error  in
                if error == nil {
                    DispatchQueue.main.async {
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "EnterEmail") as! EnterEmail
                        vc.password = password
                        vc.isEditEmail = true
                        self.navigationController?.fadeTo(vc)
                    }
                } else {
                    
                    if error!.localizedDescription.errorDescription == "The email address is already in use by another account." {
                        let errorV = MessageView.viewFromNib(layout: .cardView)
                        errorV.configureTheme(.error)
                        errorV.configureContent(title: "signin_failure".localized, body: error!.localizedDescription + "email_please_go_login_page".localized)
                        var infoConfig = SwiftMessages.defaultConfig
                        errorV.button?.isHidden = true
                        infoConfig.presentationStyle = .top
                        infoConfig.duration = .forever
                        DispatchQueue.main.async {
                            SwiftMessages.show(config: infoConfig, view: errorV)
                        }
                        
                    } else {
                        let errorV = MessageView.viewFromNib(layout: .cardView)
                        errorV.configureTheme(.error)
                        errorV.configureContent(title: "signin_failure".localized, body: error!.localizedDescription)
                        var infoConfig = SwiftMessages.defaultConfig
                        errorV.button?.isHidden = true
                        infoConfig.presentationStyle = .top
                        infoConfig.duration = .forever
                        DispatchQueue.main.async {
                            SwiftMessages.show(config: infoConfig, view: errorV)
                        }
                    }
                }
            }
        }
    }
    
    func addPassword() {
        
        view.endEditing(true)
        
        let password = passwordTextField.text ?? ""
        
        if password == "" {
            let warning = MessageView.viewFromNib(layout: .cardView)
            warning.configureTheme(.warning)
            let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
            warning.configureContent(title: "password_empty".localized, body: "please_make_sure_enter_password".localized, iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            DispatchQueue.main.async {
                SwiftMessages.show(config: warningConfig, view: warning)
            }
            
        } else {
            print("added email")
            
            var userService = UserService()
            Auth.auth().createUser(withEmail: userEmail, password: password) { _, error in
                if error == nil {
                    Auth.auth().currentUser?.getIDToken(completion: { token, error in
                        Utils.saveToken(token: token ?? "")
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "FirstnameVC") as! FirstnameVC
                        vc.userEmail = self.userEmail
                        self.navigationController?.fadeTo(vc)
                    })
                } else if let error = error as NSError? {
                    
                    if let displayNameError = error.userInfo[AuthErrorUserInfoNameKey] as? String, displayNameError == "ERROR_EMAIL_ALREADY_IN_USE" {
                        self.signIn(email: self.userEmail, password: password)
                    } else {
                        self.showFailedCardView(title: "registration_failure".localized, body: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func signIn(email: String, password: String) {
        var userServices = UserService()
        userServices.signIn(email: email, password: password) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.toMain(index: 0)
                }
            case .failure(let error):
                self.showFailedCardView(title: "signin_failure".localized, body: error.localizedDescription)
            }
        }
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
//            if error == nil {
//                // tracking event at segment
//                let track: [String: Any] = ["email": email]
//                
//                // AnalyticsTrack
////                Analytics.shared().track("User Signed In", properties: track)
////                FirebaseAnalytics.Analytics.logEvent("login", parameters: track)
////                TikTokBusiness.trackEvent("login")
//                
//                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
//                UserDefaults.standard.synchronize()
//                
//                
//                
//            } else {
//                
//            }
//        }
    }
    
    func showFailedCardView(title: String, body: String) {
        let errorV = MessageView.viewFromNib(layout: .cardView)
        errorV.configureTheme(.error)
        errorV.configureContent(title: title, body: body)
        var infoConfig = SwiftMessages.defaultConfig
        errorV.button?.isHidden = true
        infoConfig.presentationStyle = .top
        infoConfig.duration = .forever
        DispatchQueue.main.async {
            SwiftMessages.show(config: infoConfig, view: errorV)
        }
    }
    
    func login() {
        
        view.endEditing(true)
        
        let password = passwordTextField.text ?? ""
        
        if password == "" {
            let warning = MessageView.viewFromNib(layout: .cardView)
            warning.configureTheme(.warning)
            let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
            warning.configureContent(title: "password_empty".localized, body: "please_make_sure_enter_password".localized, iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            DispatchQueue.main.async {
                SwiftMessages.show(config: warningConfig, view: warning)
            }
            
        } else {
            print("added email")
            let userService = UserService()
            userService.signIn(email: userEmail, password: password) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.toMain(index: 0)
                    }
                case .failure(let error):
                    let errorV = MessageView.viewFromNib(layout: .cardView)
                    errorV.configureTheme(.error)
                    errorV.configureContent(title: "signin_failure".localized, body: error.localizedDescription)
                    var infoConfig = SwiftMessages.defaultConfig
                    errorV.button?.isHidden = true
                    infoConfig.presentationStyle = .top
                    infoConfig.duration = .forever
                    DispatchQueue.main.async {
                        SwiftMessages.show(config: infoConfig, view: errorV)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPopUp" {
            if let destVC = segue.destination as? ModalPopupViewController {
                DispatchQueue.main.async {
                    destVC.setupView(img: UIImage(named: "ic_reset_email")!, title: "reset_email".localized, detail: "reset_email_detail".localized, buttonTitle: "login".localized)
                    destVC.delegate = self
                }
            }
        }
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

extension EnterPassword: ModalPopupViewDelegate {
    func onDismissPressed() {
        
    }
    
    func onTapButtonPressed(object: Any?) {
        if (isModal) {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popWithFade()
        }
    }
}
