//
//  MyHome.swift
//  Yara
//
//  Created by Johnny Owayed on 16/10/2024.
//

import UIKit

class MyHomeVC : UIViewController {
    
    @IBOutlet weak var pageTitle:UILabel!
    
    @IBOutlet weak var element_one_title: UILabel!
    @IBOutlet weak var element_one_subtitle: UILabel!
    @IBOutlet weak var element_one_progress_view: UIView!
    @IBOutlet weak var element_one_view: UIView!
    
    @IBOutlet weak var progres_one_view: UIView!
    @IBOutlet weak var progres_one_title: UILabel!
    @IBOutlet weak var progres_one_subtitle: UILabel!
    @IBOutlet weak var progres_one_number_label: UILabel!
    
    @IBOutlet weak var progres_two_view: UIView!
    @IBOutlet weak var progres_two_title: UILabel!
    @IBOutlet weak var progres_two_subtitle: UILabel!
    @IBOutlet weak var progres_two_number_label: UILabel!
    
    @IBOutlet weak var progres_three_view: UIView!
    @IBOutlet weak var progres_three_title: UILabel!
    @IBOutlet weak var progres_three_subtitle: UILabel!
    @IBOutlet weak var progres_three_number_label: UILabel!
    
    @IBOutlet weak var steps_label:UILabel!
    
    @IBOutlet weak var element_two_title: UILabel!
    @IBOutlet weak var element_two_subtitle: UILabel!
    @IBOutlet weak var element_two_button: UIButton!
    @IBOutlet weak var element_two_view: UIView!
    
    
    @IBOutlet weak var element_three_title: UILabel!
    @IBOutlet weak var element_three_subtitle: UILabel!
    @IBOutlet weak var element_three_button: UIButton!
    @IBOutlet weak var element_three_view: UIView!
    
    @IBOutlet weak var element_four_title: UILabel!
    @IBOutlet weak var element_four_subtitle: UILabel!
    @IBOutlet weak var element_four_view: UIView!
    
    @IBOutlet weak var learnMoreLabel:UILabel!
    @IBOutlet weak var learnMoreButton:UIButton!
    
    private var progressBarView: ProgressBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupProgressView()
    }
    
    func setupUI() {
        self.pageTitle.font = CustomFont.boldFont(size: 22)
        
        self.element_one_view.layer.cornerRadius = 20
        
        self.element_one_title.font = CustomFont.semiBoldFont(size: 15)
        self.element_one_title.text = "Current Status"
        self.element_one_title.textColor = .init(hex: "999999")
        
        self.element_one_subtitle.font = CustomFont.boldFont(size: 25)
        self.element_one_subtitle.text = "Waiting for Pre-Approval"
        self.element_one_subtitle.textColor = .init(hex: "222222")
        
        self.element_one_progress_view.layer.cornerRadius = 21/2
        
        self.progres_one_view.layer.cornerRadius = 23/2
        self.progres_one_view.backgroundColor = .init(hex: "FDF5E6")
        
        self.progres_one_title.text = "Pre-Approval"
        self.progres_one_title.font = CustomFont.semiBoldFont(size: 8)
        self.progres_one_title.textColor = .init(hex: "222222")
        
        self.progres_one_subtitle.text = "2-3 weeks"
        self.progres_one_subtitle.font = CustomFont.semiBoldFont(size: 8)
        self.progres_one_subtitle.textColor = .init(hex: "999999")
        
        self.progres_one_number_label.text = "1"
        self.progres_one_number_label.font = CustomFont.semiBoldFont(size: 10)
        self.progres_one_number_label.textColor = .init(hex: "999999")
        
        self.progres_two_view.layer.cornerRadius = 23/2
        self.progres_two_view.backgroundColor = .init(hex: "4690F7")?.withAlphaComponent(0.22)
        
        self.progres_two_title.text = "View Property"
        self.progres_two_title.font = CustomFont.semiBoldFont(size: 8)
        self.progres_two_title.textColor = .init(hex: "222222")
        
        self.progres_two_subtitle.text = "1 week"
        self.progres_two_subtitle.font = CustomFont.semiBoldFont(size: 8)
        self.progres_two_subtitle.textColor = .init(hex: "999999")
        
        self.progres_two_number_label.text = "2"
        self.progres_two_number_label.font = CustomFont.semiBoldFont(size: 10)
        self.progres_two_number_label.textColor = .init(hex: "999999")
        
        self.progres_three_view.layer.cornerRadius = 23/2
        self.progres_three_view.backgroundColor = .init(hex: "35B17B")?.withAlphaComponent(0.5)
        self.progres_three_title.text = "Purchase"
        self.progres_three_title.font = CustomFont.semiBoldFont(size: 8)
        self.progres_three_title.textColor = .init(hex: "222222")
        
        self.progres_three_subtitle.text = "1 week"
        self.progres_three_subtitle.font = CustomFont.semiBoldFont(size: 8)
        self.progres_three_subtitle.textColor = .init(hex: "999999")
        
        self.progres_three_number_label.text = "3"
        self.progres_three_number_label.font = CustomFont.semiBoldFont(size: 10)
        self.progres_three_number_label.textColor = .init(hex: "999999")
        
        self.steps_label.text = "Step"
        self.steps_label.font = CustomFont.boldFont(size: 16)
        self.steps_label.textColor = .init(hex: "9D9D9D")
        
        self.element_two_view.layer.cornerRadius = 20
        self.element_two_view.addLightShadow()
        
        self.element_two_title.text = "1- Pre-Approval"
        self.element_two_title.font = CustomFont.semiBoldFont(size: 18)
        self.element_two_title.textColor = .init(hex: "222222")
        
        self.element_two_subtitle.text = "Mortgage pre-approval means getting approved for a loan from the bank to buy a property."
        self.element_two_subtitle.font = CustomFont.semiBoldFont(size: 13)
        self.element_two_subtitle.textColor = .init(hex: "999999")
        
        self.element_two_button.setTitle("View Terms", for: .normal)
        self.element_two_button.titleLabel?.font = CustomFont.semiBoldFont(size: 12)
        self.element_two_button.layer.cornerRadius = 33/2
        self.element_two_button.backgroundColor = .init(hex: "F9FAFB")
        self.element_two_button.setTitleColor(UIColor(hex: "999999"), for: .normal)
        
        self.element_three_view.layer.cornerRadius = 20
        self.element_three_view.addLightShadow()
        
        self.element_three_title.text = "2- View Property"
        self.element_three_title.font = CustomFont.semiBoldFont(size: 18)
        self.element_three_title.textColor = .init(hex: "222222")
        
        self.element_three_subtitle.text = "Our agent will contact you to schedule a viewing and finalize the purchase process."
        self.element_three_subtitle.font = CustomFont.semiBoldFont(size: 13)
        self.element_three_subtitle.textColor = .init(hex: "999999")
        
        self.element_three_button.setTitle("Schedule", for: .normal)
        self.element_three_button.titleLabel?.font = CustomFont.semiBoldFont(size: 12)
        self.element_three_button.layer.cornerRadius = 33/2
        self.element_three_button.backgroundColor = .init(hex: "F9FAFB")
        self.element_three_button.setTitleColor(UIColor(hex: "999999"), for: .normal)
        
        self.element_four_view.layer.cornerRadius = 20
        self.element_four_view.addLightShadow()
        
        self.element_four_title.text = "3- Purchase"
        self.element_four_title.font = CustomFont.semiBoldFont(size: 18)
        self.element_four_title.textColor = .init(hex: "222222")
        
        self.element_four_subtitle.text = "After purchase, you pay the monthly mortgage directly to the bank instead of rent. You can sell the property and close the mortgage at any time."
        self.element_four_subtitle.font = CustomFont.semiBoldFont(size: 13)
        self.element_four_subtitle.textColor = .init(hex: "999999")
        
        self.learnMoreLabel.text = "100% Free. No hidden fees."
        self.learnMoreLabel.textColor = UIColor(hex: "#999999")
        self.learnMoreLabel.font = CustomFont.semiBoldFont(size: 10)
        
        self.learnMoreButton.setTitle("Learn more", for: .normal)
        self.learnMoreButton.setTitleColor(UIColor(hex: "#999999"), for: .normal)
        self.learnMoreButton.titleLabel?.font = CustomFont.semiBoldFont(size: 10)
        self.learnMoreButton.backgroundColor = UIColor(hex: "#F9FAFB")
        
    }
    
    private func setupProgressView() {
        // Remove any existing subviews from element_one_progress_view
        element_one_progress_view.subviews.forEach { $0.removeFromSuperview() }
        
        // Create progress view with exact frame
        progressBarView = ProgressBarView(frame: CGRect(
            x: 0,
            y: 0,
            width: element_one_progress_view.bounds.width,
            height: 21 // Exact height as specified
        ))
        
        // Set up constraints to maintain size
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        element_one_progress_view.addSubview(progressBarView)
        
        // Add constraints
        NSLayoutConstraint.activate([
            progressBarView.leadingAnchor.constraint(equalTo: element_one_progress_view.leadingAnchor),
            progressBarView.trailingAnchor.constraint(equalTo: element_one_progress_view.trailingAnchor),
            progressBarView.centerYAnchor.constraint(equalTo: element_one_progress_view.centerYAnchor),
            progressBarView.heightAnchor.constraint(equalToConstant: 21)
        ])
        
        // Start at stage 1 after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.progressBarView.animateProgress(to: 1)
        }
    }
    
    func updateProgress(to stage: Int) {
        progressBarView.animateProgress(to: stage)
        
        // Update UI to reflect current stage
        switch stage {
        case 1:
            element_one_subtitle.text = "Pre-Approval"
        case 2:
            element_one_subtitle.text = "View Property"
        case 3:
            element_one_subtitle.text = "Purchase"
        default:
            break
        }
    }
}
