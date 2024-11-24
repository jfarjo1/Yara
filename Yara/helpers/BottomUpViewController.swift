//
//  BottomUpViewController.swift
//  Yara
//
//  Created by Johnny Owayed on 26/10/2024.
//

import Firebase
import NVActivityIndicatorView
import MessageUI
import SwiftMessages
import FirebaseAuth

import UIKit

class BottomUpViewController: UIViewController {
    @IBOutlet var tblView: UITableView!

    @IBOutlet var swipeHolderView: UIView!

    @IBOutlet var innerContentView: UIView!

    var alphaComponent = 0.2

    var userId: String = ""

    var userFullName: String = ""

    var userEmail: String = ""
    var dimmedViewColor = UIColor(hexString: "#222222")

    var originalYPositionOfPopUp: CGFloat = 0.0
    var botttomConstraint: CGFloat = 0.0
    
    var data = [String]() {
        didSet {
            tblView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        innerContentView.addViewBorder(borderColor: UIColor.clear.cgColor, borderWidth: 0.0, borderCornerRadius: 40.0)
        swipeHolderView.addViewBorder(borderColor: UIColor.clear.cgColor, borderWidth: 0.0, borderCornerRadius: 3.0)

        data = ["whatsapp_us".localized, "need_help_email".localized, "close".localized]
        tblView.dataSource = self
        tblView.delegate = self

        // making separator edge to edge
        tblView.layoutMargins = UIEdgeInsets.zero
        tblView.separatorInset = UIEdgeInsets.zero
        tblView.separatorColor = .lightGray.withAlphaComponent(0.3)
        tblView.rowHeight = 60
        tblView.isScrollEnabled = tblView.contentSize.height > tblView.frame.size.height

        // Swipe down
        let pgrFullView = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(pgrFullView) // applying pan gesture on full main view

        // Loading information
        if let UID = Auth.auth().currentUser?.uid {
            userId = UID
        }

        if let firstName = UserDefaults.standard.string(forKey: "firstName") {
            userFullName = firstName
            if let lastName = UserDefaults.standard.string(forKey: "firstName") {
                userFullName += " " + lastName
            }
            print(userFullName)
        }

        if let email = UserDefaults.standard.string(forKey: "email") {
            userEmail = email
        }
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        originalYPositionOfPopUp = self.view.frame.size.height - innerContentView.frame.size.height - botttomConstraint
////        originalYPositionOfPopUp = innerContentView.frame.origin.y // + 100 // i dont know why +30 maybe the margin at the bottom
//
//
//
////        UIView.animate(withDuration: 0.3,
////                       delay: 0,
////                       animations: {
////            self.view.backgroundColor = UIColor.black.withAlphaComponent(self.alphaComponent)
////            self.slideViewTo(0, self.originalYPositionOfPopUp)
////        })
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originalYPositionOfPopUp = self.view.frame.size.height - innerContentView.frame.size.height - botttomConstraint
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .transitionFlipFromBottom,
                       animations: {
            self.view.backgroundColor = self.dimmedViewColor.withAlphaComponent(self.alphaComponent)
            self.slideViewTo(self.view.frame.origin.x, self.originalYPositionOfPopUp)
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.backgroundColor = UIColor.clear
    }

    func slideViewTo(_ x: CGFloat, _ y: CGFloat) {
        innerContentView.frame.origin = CGPoint(x: x, y: y)
    }
    
    // writing this function so that user may land from self to uiTabBarController with first index as selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let minimumVelocityToHide: CGFloat = 750
        let minimumScreenRatioToHide: CGFloat = 0.50
        let animationDuration: TimeInterval = 0.2

        

        switch panGesture.state {
        // case .began, .changed:
        case .changed:
            // If pan started or is ongoing then slide the view to follow the finger
            let translation = panGesture.translation(in: view)
            //            print("translation.y: \(translation.y)")
            if translation.y > 0 { // only down movement to handle
                slideViewTo(0, originalYPositionOfPopUp + translation.y)
            }
        case .ended:
            // If pan ended, decide it we should close or reset the view based on the final position and the speed of the gesture
            let translation = panGesture.translation(in: view)
            let velocity = panGesture.velocity(in: view)
            let closing = (translation.y > innerContentView.frame.size.height * minimumScreenRatioToHide) || // checking on y position
                (velocity.y > minimumVelocityToHide) // checking on y velocity

            if closing {
                dismiss(animated: true)
            } else {
                // If not closing, reset the view to the top
                if translation.y > 0 {
                    UIView.animate(withDuration: animationDuration, animations: {
                        self.slideViewTo(0, self.originalYPositionOfPopUp)
                    })
                }
            }
        default:
            print(panGesture.state)
        }
    }
}

extension BottomUpViewController: UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editProfileCell") as! EditProfileCell
        let index = indexPath.row
        let model = data[index]

        cell.lblTitle.font = CustomFont.semiBoldFont(size: 20)
        
        // Title of the card
        cell.lblTitle.text = model
        if indexPath.row == data.count - 1 {
            cell.lblTitle.textColor = .lightGray
        } else {
            cell.lblTitle.textColor = .black
        }
        // removing left padding
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { // whats app chat
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            guard let url = URL(string: " https://bit.ly/yara-live-chat") else { return }
            UIApplication.shared.open(url)
        } else if indexPath.row == 1 {
            openGmailCompose(to: "hello@getyara.io")
        } else if indexPath.row == data.count - 1 {
            dismiss(animated: true, completion: nil)
        }
    }

    func openGmailCompose(to emailAddress: String) {
        sendEmail(emailAddress: emailAddress)
//        if let emailURL = URL(string: "mailto:\(emailAddress)") {
//            if UIApplication.shared.canOpenURL(emailURL) {
//                UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
//            } else {
//                // Email app is not available, handle this case
//            }
//        } else {
//            // Invalid URL, handle this case
//        }
    }
    
    func sendEmail(emailAddress: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            guard let uid = Auth.auth().currentUser?.uid else {return}
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailAddress])
            mail.setMessageBody("<p>Hello, I need help. My User ID \(uid)!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    // The basic idea is to create a new section (rather than a new row) for each array item. The sections can then be spaced using the section header height.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}


class EditProfileCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle.font = CustomFont.semiBoldFont(size: 20)
        reset()
    }

    private func reset() {
        lblTitle.text = ""
    }
    
}

