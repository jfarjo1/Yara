//
//  ApplyScreen.swift
//  Yara
//
//  Created by Johnny Owayed on 20/10/2024.
//

import UIKit

class ApplyScreen: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var back_button: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var employmentStatusTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var monthlySalaryTextField: UITextField!
    @IBOutlet weak var nationalityTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var emiratesIDFrontTextField: UITextField!
    @IBOutlet weak var emiratesIDBackTextField: UITextField!
    @IBOutlet weak var sixMonthBankSatementTextField: UITextField!
    
    @IBOutlet weak var uploadEmiratesIDFrontButton: UIButton!
    @IBOutlet weak var uploadEmiratesIDBackButton: UIButton!
    @IBOutlet weak var uploadSixMonthBankStatementButton: UIButton!
    
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var learnMoreButton: UIButton!
    @IBOutlet weak var learnMoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        
        self.back_button.setRounded()
        self.titleLabel.text = "Apply Now"
        self.titleLabel.font = CustomFont.boldFont(size: 22)
        
        self.firstNameTextField.setConfigForApply()
        self.firstNameTextField.placeholder = "First Name"
        self.firstNameTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.lastNameTextField.setConfigForApply()
        self.lastNameTextField.placeholder = "Last Name"
        self.lastNameTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.dateOfBirthTextField.setConfigForApply()
        self.dateOfBirthTextField.placeholder = "Date of Birth"
        self.dateOfBirthTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.employmentStatusTextField.setConfigForApply()
        self.employmentStatusTextField.placeholder = "Employment Status"
        self.employmentStatusTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.addressTextField.setConfigForApply()
        self.addressTextField.placeholder = "Address"
        self.addressTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.monthlySalaryTextField.setConfigForApply()
        self.monthlySalaryTextField.placeholder = "Monthly Salary"
        self.monthlySalaryTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.nationalityTextField.setConfigForApply()
        self.nationalityTextField.placeholder = "Nationality"
        self.nationalityTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.phoneNumberTextField.setConfigForApply()
        self.phoneNumberTextField.placeholder = "Phone Number"
        self.phoneNumberTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.emiratesIDFrontTextField.setConfigForApply()
        self.emiratesIDFrontTextField.placeholder = "Emirates ID Front"
        self.emiratesIDFrontTextField.font = CustomFont.semiBoldFont(size: 14)
        self.emiratesIDFrontTextField.addUploadButton()
        
        self.emiratesIDBackTextField.setConfigForApply()
        self.emiratesIDBackTextField.placeholder = "Emirates ID Back"
        self.emiratesIDBackTextField.font = CustomFont.semiBoldFont(size: 14)
        self.emiratesIDBackTextField.isUserInteractionEnabled = false
        self.emiratesIDBackTextField.addUploadButton()
        
        self.sixMonthBankSatementTextField.setConfigForApply()
        self.sixMonthBankSatementTextField.placeholder = "6 months bank statement"
        self.sixMonthBankSatementTextField.font = CustomFont.semiBoldFont(size: 14)
        self.sixMonthBankSatementTextField.isUserInteractionEnabled = false
        self.sixMonthBankSatementTextField.addUploadButton()
        
        self.applyButton.layer.cornerRadius = 45/2
        self.applyButton.clipsToBounds = true
        self.applyButton.setTitle("Submit", for: .normal)
        self.applyButton.backgroundColor = UIColor(hex: "#484848")
        self.applyButton.titleLabel?.font = CustomFont.semiBoldFont(size: 17)
        self.applyButton.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        
        learnMoreLabel.text = "100% Free. No hidden fees."
        learnMoreLabel.textColor = UIColor(hex: "#999999")
        learnMoreLabel.font = CustomFont.semiBoldFont(size: 10)
        
        learnMoreButton.setTitle("Learn more", for: .normal)
        learnMoreButton.setTitleColor(UIColor(hex: "#999999"), for: .normal)
        learnMoreButton.titleLabel?.font = CustomFont.semiBoldFont(size: 10)
        learnMoreButton.backgroundColor = UIColor(hex: "#F9FAFB")
        
        
        
        _ = TapGestureRecognizer.addTapGesture(to: applyButton) {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MabroukScreenVC") as! MabroukScreenVC
            self.navigationController?.pushViewController(vc, animated: true)
        }

        _ = TapGestureRecognizer.addTapGesture(to: learnMoreButton) {
            self.dismiss(animated: true) {
                
            }
        }
    }
    
    
}

extension UITextField {
    func setConfigForApply() {
        self.addDottedBorder(cornerRadius: 10, dotSize: 4, spacing: 4)
        self.setLeftPaddingPoints(20)
    }
}
