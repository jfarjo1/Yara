//
//  ViewController.swift
//  Yara
//
//  Created by Johnny Owayed on 12/10/2024.
//

import UIKit

class OnbTwo: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView_center: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label.numberOfLines = 3
        self.label.setGradientTextColor(text: "Start owning for $25K and pay like you're renting", font: CustomFont.interMediumFont(size: 35), colors: [UIColor(hex: "#B0B5D5")!, UIColor(hex: "#B0B5D5")!])
        
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 30
        
        imageView.addSubview(imageView_center)
        
        view.sendSubviewToBack(imageView)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.imageView_center.popIn(duration: 2, completion: { _ in
            self.addMotionEffects()
        })
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

