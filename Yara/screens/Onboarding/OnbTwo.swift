//
//  ViewController.swift
//  Yara
//
//  Created by Johnny Owayed on 12/10/2024.
//

import UIKit

class OnbTwo: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView_center: UIImageView!
    
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoHeight.constant = ScreenRatioHelper.adjustedHeight(492)
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 30
        
        imageView.addSubview(imageView_center)
        
        view.sendSubviewToBack(imageView)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.addMotionEffects()
    }
    
    func addMotionEffects() {
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -100
        horizontalMotionEffect.maximumRelativeValue = 100
        
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -100
        verticalMotionEffect.maximumRelativeValue = 100
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        imageView_center.addMotionEffect(motionEffectGroup)
    }
}

