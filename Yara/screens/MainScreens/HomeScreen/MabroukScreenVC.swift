//
//  MabroukScreenVC.swift
//  Yara
//
//  Created by Johnny Owayed on 21/10/2024.
//

import UIKit

class MabroukScreenVC: UIViewController {
    
    @IBOutlet weak var mabroukImage: UIImageView!
    @IBOutlet weak var subLabel:UILabel!
    @IBOutlet weak var viewProgressButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.viewProgressButton.layer.cornerRadius = 45/2
        self.viewProgressButton.clipsToBounds = true
        self.viewProgressButton.setTitle("View Progress", for: .normal)
        self.viewProgressButton.backgroundColor = UIColor(hex: "#484848")
        self.viewProgressButton.titleLabel?.font = CustomFont.semiBoldFont(size: 16)
        self.viewProgressButton.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        
        self.subLabel.font = CustomFont.semiBoldFont(size: 18)
        self.subLabel.textColor = UIColor(hex: "#9C9EA0")
        self.subLabel.text = "Your application has been submitted"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.startRotationAnimation()
    }
    
    func startRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 20
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isRemovedOnCompletion = false
        
        self.mabroukImage.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    @IBAction func viewProgressButtonTapped(_ sender: Any) {
        TapticEngine.impact.feedback(.medium)
        self.toMain(index: 1)
    }
}
