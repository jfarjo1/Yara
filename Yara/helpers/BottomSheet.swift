//
//  BottomSheet.swift
//  Yara
//
//  Created by Johnny Owayed on 19/10/2024.
//

//
//  DeviceSupportViewController.swift
//  Simly
//

import UIKit

protocol HowItWorksViewControllerDelegate: BaseModalPopupViewDelegate {
    func onTapButtonPressed(type: String)
}

class HowItWorksViewController: BasePopupViewController {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailOneLabel: UILabel!
    @IBOutlet var detailTwoLabel: UILabel!
    @IBOutlet var detailThreeLabel: UILabel!
    @IBOutlet var closeView: UIView!
    @IBOutlet var onetime_button: UIButton!
    @IBOutlet var onetime_info: UILabel!
    @IBOutlet var applyNow: UIButton!
    @IBOutlet var learnMore_button: UIButton!
    @IBOutlet var learn_more_label: UILabel!

    var obj: Any?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "How it works"
        titleLabel.font = CustomFont.semiBoldFont(size: 22)

        detailOneLabel.text = "1- Submit your details, and we will apply for your mortgage pre-approval."
        detailOneLabel.textColor = UIColor(hex: "#999999")
        detailOneLabel.font = CustomFont.semiBoldFont(size: 15)

        detailTwoLabel.text = "2- Once approved, our agent will assist you in purchasing the property."
        detailTwoLabel.textColor = UIColor(hex: "#999999")
        detailTwoLabel.font = CustomFont.semiBoldFont(size: 15)
        
        detailThreeLabel.text = "3- After purchase, you will pay the down payment and monthly fee to the bank"
        detailThreeLabel.textColor = UIColor(hex: "#999999")
        detailThreeLabel.font = CustomFont.semiBoldFont(size: 15)
        
        applyNow.layer.cornerRadius = 45/2
        applyNow.clipsToBounds = true
        applyNow.setTitle("Apply Now", for: .normal)
        applyNow.backgroundColor = UIColor(hex: "#484848")
        applyNow.titleLabel?.font = CustomFont.semiBoldFont(size: 17)
        applyNow.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        
        onetime_button.setTitle("One time: $25k", for: .normal)
        onetime_button.layer.cornerRadius = 33/2
        onetime_button.clipsToBounds = true
        onetime_button.titleLabel?.font = CustomFont.semiBoldFont(size: 13)
        onetime_button.setTitleColor(UIColor(hex: "#A9A9A9"), for: .normal)
        onetime_button.applyGradient(colors: [(UIColor(hex:"#040404") ?? .black).cgColor, (UIColor(hex:"#636363") ?? .gray).cgColor])
        
        onetime_info.text = "and 1000$ per month"
        onetime_info.textColor = UIColor(hex: "#999999")
        onetime_info.font = CustomFont.semiBoldFont(size: 13)
        
        learn_more_label.text = "100% Free. No hidden fees."
        learn_more_label.textColor = UIColor(hex: "#999999")
        learn_more_label.font = CustomFont.semiBoldFont(size: 10)
        
        learnMore_button.setTitle("Learn more", for: .normal)
        learnMore_button.setTitleColor(UIColor(hex: "#999999"), for: .normal)
        learnMore_button.titleLabel?.font = CustomFont.semiBoldFont(size: 10)
        learnMore_button.backgroundColor = UIColor(hex: "#F9FAFB")

        _ = TapGestureRecognizer.addTapGesture(to: applyNow) {
            self.dismiss(animated: true) {
                if let delegate = self.delegate as? HowItWorksViewControllerDelegate {
                    delegate.onTapButtonPressed(type: "HowItWorks")
                }
            }
        }

        _ = TapGestureRecognizer.addTapGesture(to: closeView) {
            self.dismiss(animated: true) {
                self.delegate?.onDismiss(type: self.popupType)
            }
        }
    }
}
