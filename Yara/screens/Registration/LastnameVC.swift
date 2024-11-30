//
//  LastNameViewController.swift
//  Yara
//
//  Created by Johnny Owayed on 15/10/2024.
//

//
//  EnterNameViewController.swift
//  Simly
//

import FirebaseAnalytics
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftMessages
import UIKit

class LastnameVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var backBgView: UIView!
    @IBOutlet var nextBgView: UIView!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var lblNext: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    
    @IBOutlet weak var backButtonImage: UIImageView!
    var subTitle: String?
    var userEmail:String!
    var firstName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        backBgView.setRounded()
        
        lastNameTextField.delegate = self
        lastNameTextField.becomeFirstResponder()
        lblNext.text = "next".localized
        
    }
    
    private func setupInterface() {
        
        self.backButtonImage.image = UIImage(named: "back_arrow")
        
        titleLabel.text = "whats_lastname".localized
        titleLabel.font = CustomFont.semiBoldFont(size: 30)
        
        lblSubTitle.text = "now_please_enter_last_name".localized
        lblSubTitle.font = CustomFont.semiBoldFont(size: 18)
        
        lastNameTextField.placeholder = "last_name_placeholder".localized
        lastNameTextField.font = CustomFont.semiBoldFont(size: 29)
        
        lblNext.font = CustomFont.semiBoldFont(size: 22)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func addName(_ sender: Any) {
        if let lastName = lastNameTextField.text {
            if lastName.isEmpty {
                let warning = MessageView.viewFromNib(layout: .cardView)
                warning.configureTheme(.warning)
                let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
                warning.configureContent(title: "last_name_empty".localized, body: "please_make_sure_to_enter_last_name".localized, iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
                SwiftMessages.show(config: warningConfig, view: warning)
            } else {
                UserDefaults.standard.set(lastNameTextField.text!.trim(), forKey: "lastName")
                
                nextBgView.popOut()
                TapticEngine.impact.feedback(.medium)
                
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
                vc.firstName = self.firstName
                vc.lastName = self.lastNameTextField.text?.trim()
                vc.email = self.userEmail
                self.navigationController?.fadeTo(vc)
                
//                var val = UserDefaults.standard.bool(forKey: "areNotificationsEnabled")
//                TapticEngine.impact.feedback(.medium)
//                let sb = UIStoryboard(name: "Main", bundle: nil)
//                let vc = sb.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
//                vc.firstName = self.firstName
//                vc.lastName = self.lastNameTextField.text?.trim()
//                vc.userEmail = self.userEmail
//                vc.areNotificationsEnabled = val
//                self.navigationController?.fadeTo(vc)
                
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 22
    }
    
    
    // MARK: - Navigation
    
    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popWithFade()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMain" {
            if let destVC = segue.destination as? UITabBarController {
                destVC.selectedIndex = 2 // (sender as! UIButton).tag
            }
        }
    }
}
