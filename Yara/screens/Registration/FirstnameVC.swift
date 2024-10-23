//
//  FirstNameViewController.swift
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

class FirstnameVC: UIViewController, UITextFieldDelegate {
    @IBOutlet var firstnameLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var backBgView: UIView!
    @IBOutlet var nextBgView: UIView!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lblNext: UILabel!
    
    @IBOutlet weak var backButtonImage: UIImageView!
    
    var userEmail:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        backBgView.setRounded()
        
        firstNameTextField.delegate = self
        firstNameTextField.becomeFirstResponder()
        
        lblNext.text = "next".localized
    }
    
    private func setupInterface() {
        
        self.backButtonImage.image = UIImage(named: "back_arrow")
        
        firstnameLabel.text = "whats_firstname".localized
        firstnameLabel.font = CustomFont.semiBoldFont(size: 33)
        
        subtitleLabel.text = "choose_display_name".localized
        subtitleLabel.font = CustomFont.semiBoldFont(size: 18)
        
        firstNameTextField.placeholder = "first_name_placeholder".localized
        firstnameLabel.font = CustomFont.semiBoldFont(size: 29)
        
        lblNext.font = CustomFont.semiBoldFont(size: 22)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func addName(_ sender: Any) {
        
        if let firstName = firstNameTextField.text {
            if firstName.isEmpty {
                let warning = MessageView.viewFromNib(layout: .cardView)
                warning.configureTheme(.warning)
                let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
                warning.configureContent(title: "first_name_empty".localized, body: "please_make_sure_enter_first_name".localized, iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
                SwiftMessages.show(config: warningConfig, view: warning)
                
            } else {
                
                //                nextBgView.popOut()
                TapticEngine.impact.feedback(.medium)
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "LastnameVC") as! LastnameVC
                vc.userEmail = self.userEmail
                vc.firstName = firstNameTextField.text!.trim()
                self.navigationController?.fadeTo(vc)
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
