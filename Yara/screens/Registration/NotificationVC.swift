//
//  NotificationVC.swift
//  Yara
//
//  Created by Johnny Owayed on 15/10/2024.
//

//
//  EnableNotificationsViewController.swift
//  Simly
//

import FirebaseAnalytics
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import OneSignalFramework
import UIKit
import Lottie

class NotificationVC: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var notificationsLabel: UILabel!
    @IBOutlet var spamLabel: UILabel!
    @IBOutlet var backBgView: UIView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var imgBgView: UIView!
    @IBOutlet var enabledImg: UIImageView!
    @IBOutlet var status: UILabel!
    @IBOutlet weak var lottieView: LottieAnimationView!
    @IBOutlet weak var backButtonImage: UIImageView!
    @IBOutlet weak var skipButton: UIButton!
    
    var areNotificationsEnabled: Bool = false
    var firstName:String!
    var lastName:String!
    var email:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        enabledImg.isHidden = true
        enabledImg.layer.cornerRadius = 15
        
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 0.5
        lottieView.play()
        backBgView.setRounded()
        imgBgView.setRounded()
        
        bgView.popIn()
        
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 20
        
    }
    
    private func setupInterface() {
        
        self.backButtonImage.image = UIImage(named: "back_arrow")
        
        titleLabel.text = "stay_in_loop".localized
        titleLabel.font = CustomFont.semiBoldFont(size: 31)
        
        subtitleLabel.text = "get_notified_about_data".localized
        subtitleLabel.font = CustomFont.semiBoldFont(size: 18)
        
        notificationsLabel.text = "notifications".localized
        notificationsLabel.font = CustomFont.semiBoldFont(size: 24)
        
        spamLabel.text = "we_wont_spam".localized
        spamLabel.font = CustomFont.semiBoldFont(size: 12)
        
        skipButton.setTitle("skip".localized, for: .normal)
        skipButton.titleLabel?.font = CustomFont.semiBoldFont(size: 22)
        
        status.text = "enable_now".localized
        status.font = CustomFont.semiBoldFont(size: 13)
    }
    
    @IBAction func notificationsPressed(_ sender: Any) {
        btnNotificationsTapped()
    }
    
    @IBAction func skip(_ sender: Any) {
        btnSkipTapped()
    }
    
    // this method chane the lable to "enable" and make the check box visible
    func enablingTheLabel() {
        enabledImg.isHidden = false
        status.text = "enabled".localized
        enabledImg.popIn()
    }
    
    func btnNotificationsTapped() {
        areNotificationsEnabled = !areNotificationsEnabled
        
        if areNotificationsEnabled {
            registerForRemoteNotification()
        } else {
            enabledImg.isHidden = true
            status.text = "enable_now".localized
            bgView.popIn()
            unRegisterForRemoteNotification()
        }
    }
    
    func btnSkipTapped() {
        UserDefaults.standard.set(areNotificationsEnabled, forKey: "areNotificationsEnabled")
        
        bgView.popOut()
        TapticEngine.impact.feedback(.medium)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
        vc.firstName = self.firstName
        vc.lastName = self.lastName
        vc.userEmail = self.email
        vc.areNotificationsEnabled = areNotificationsEnabled
        self.navigationController?.fadeTo(vc)
        
    }
    
    func unRegisterForRemoteNotification() {
        OneSignal.User.pushSubscription.optOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.btnSkipTapped()
        }
    }
    
    func registerForRemoteNotification() {
        OneSignal.Notifications.requestPermission{ accepted in
            print("Notifications: \(accepted)")
            
            self.areNotificationsEnabled = accepted
            UserDefaults.standard.set(accepted, forKey: "areNotificationsEnabled")
            
            if accepted == true {
                TapticEngine.notification.feedback(.success)
                self.enablingTheLabel()
            } else if accepted == false {
                self.areNotificationsEnabled = accepted
                print("Notifications: \(accepted)")
                TapticEngine.impact.feedback(.medium)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
                vc.firstName = self.firstName
                vc.lastName = self.lastName
                vc.userEmail = self.email
                vc.areNotificationsEnabled = self.areNotificationsEnabled
                self.navigationController?.fadeTo(vc)
            }
        }
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
//extension EnableNotificationsViewController: ModalPopupV2ViewDelegate {
//    func onTapButtonPressed(type: String) {
//        if !areNotificationsEnabled {
//            enablingTheLabel()
//            registerForRemoteNotification()
//        } else {
//            enabledImg.isHidden = true
//            status.text = "enable_now".localized
//            bgView.popIn()
//            unRegisterForRemoteNotification()
//        }
//        areNotificationsEnabled = !areNotificationsEnabled
//    }
//
//    func onDismiss(type: String) {
//
//    }
//}

