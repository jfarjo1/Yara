import UIKit

class OnbOne: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView_center: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label.numberOfLines = 3
        self.label.setGradientTextColor(text: "Renting costs you money without ownership", font: CustomFont.interMediumFont(size: 35), colors: [UIColor(hex: "#848484")!, UIColor(hex: "#C1C1C1")!])
        
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 30
        
        imageView.addSubview(imageView_center)
        
        view.sendSubviewToBack(imageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.imageView_center.popIn(duration: 2, completion: { _ in
            self.addMotionEffects()
            self.startRotationAnimation()
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
    
    func startRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 10
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isRemovedOnCompletion = false
        
        imageView_center.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}
