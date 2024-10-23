//
//  OnbThree.swift
//  Yara
//
//  Created by Johnny Owayed on 13/10/2024.
//
import UIKit

class Welcome: UIViewController {
    
    @IBOutlet weak var center_image:UIImageView!
    @IBOutlet weak var title_label:UILabel!
    @IBOutlet weak var subtitle_label:UILabel!
    
    @IBOutlet weak var signUpEmail:UIView!
    @IBOutlet weak var label_email:UILabel!
    
    @IBOutlet weak var signUpApple:UIView!
    @IBOutlet weak var label_apple:UILabel!
    
    @IBOutlet weak var label_signup_disclaimer:UILabel!
    @IBOutlet weak var label_signup:UILabel!
    @IBOutlet weak var signup:UIView!
    @IBOutlet weak var label_policy_disclaimer:PolicyDisclaimerLabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI() {
        title_label.setGradientTextColor(text: "Meet Yara", font: CustomFont.interMediumFont(size: 45), colors: [UIColor(hex: "#848484")!, UIColor(hex: "#C1C1C1")!])
        
        subtitle_label.setGradientTextColor(text: "from renting to owning, made simple.", font: CustomFont.interMediumFont(size: 18), colors: [UIColor(hex: "#848484")!, UIColor(hex: "#C1C1C1")!])
        
        signUpEmail.layer.cornerRadius = 20
        signUpEmail.backgroundColor = UIColor.init(hex: "#F8F8FA")
        label_email.text = "Sign up with Email"
        label_email.font = CustomFont.semiBoldFont(size: 18)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signupEmailPressed(_:)))
        signUpEmail.addGestureRecognizer(tapGesture)
        signUpEmail.isUserInteractionEnabled = true
        
        
        let signupTap = UITapGestureRecognizer(target: self, action: #selector(signinPressed(_:)))
        signup.addGestureRecognizer(signupTap)
        signup.isUserInteractionEnabled = true
        signup.backgroundColor = UIColor(hex: "#222222")
        signup.layer.cornerRadius = 11.5
        
        
        let appleTap = UITapGestureRecognizer(target: self, action: #selector(applePressed(_:)))
        signUpApple.addGestureRecognizer(appleTap)
        signUpApple.isUserInteractionEnabled = true
        signUpApple.backgroundColor = UIColor.init(hex: "#222222")
        signUpApple.layer.cornerRadius = 20
        label_apple.text = "Sign up with Apple"
        label_apple.font = CustomFont.semiBoldFont(size: 18)
        
        label_signup_disclaimer.text = "Already have an account?"
        label_signup_disclaimer.textColor = UIColor(hex: "#F8F8FA")
        label_signup_disclaimer.font = CustomFont.semiBoldFont(size: 15)
        label_signup.text = "Sign in"
        
        label_signup.font = CustomFont.boldFont(size: 12)
       
        
        label_policy_disclaimer.setupPolicyDisclaimer()
        label_policy_disclaimer.font = CustomFont.semiBoldFont(size: 10)
    }
    
    @objc func applePressed(_ sender: UITapGestureRecognizer) {
        TapticEngine.impact.feedback(.medium)
//        startSignInWithAppleFlow()
    }
    
    @objc func signupEmailPressed(_ sender: UITapGestureRecognizer) {
        TapticEngine.impact.feedback(.medium)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "EnterEmail") as! EnterEmail
        vc.isSignUp = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func signinPressed(_ sender: UITapGestureRecognizer) {
        TapticEngine.impact.feedback(.medium)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "EnterEmail") as! EnterEmail
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class PolicyDisclaimerLabel: UILabel {
    private var interactiveRanges: [(NSRange, CGRect, URL)] = []
    
    func setupPolicyDisclaimer() {
        let fullString = "By tapping sign up and using Ownly you\nagree to our terms and privacy policy."
        let attributedString = NSMutableAttributedString(string: fullString)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular),
            .foregroundColor: UIColor(white: 0.6, alpha: 1) // Light gray color
        ]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: fullString.count))
        
        self.attributedText = attributedString
        self.numberOfLines = 0 // Allow multiple lines
        self.lineBreakMode = .byWordWrapping
        
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(),
              let attributedText = self.attributedText else { return }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: rect.size)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.maximumNumberOfLines = self.numberOfLines
        layoutManager.addTextContainer(textContainer)
        
        context.saveGState()
        context.setFillColor(UIColor(hex: "#222222")!.cgColor)
        
        interactiveRanges.removeAll()
        
        let keywordURLs = [
            "terms": URL(string: "https://simly.io/terms")!,
            "privacy policy": URL(string: "https://simly.io/privacy")!
        ]
        
        keywordURLs.forEach { keyword, url in
            if let range = (self.text as NSString?)?.range(of: keyword), range.location != NSNotFound {
                var glyphRange = NSRange()
                layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)
                
                let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
                let backgroundRect = boundingRect.insetBy(dx: -4, dy: -2)
                
                let path = UIBezierPath(roundedRect: backgroundRect,
                                        byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                                        cornerRadii: CGSize(width: backgroundRect.height, height: backgroundRect.height))
                context.addPath(path.cgPath)
                context.fillPath()
                
                interactiveRanges.append((range, backgroundRect, url))
            }
        }
        
        context.restoreGState()
        
        // Draw the text on top of the background
        layoutManager.drawGlyphs(forGlyphRange: NSRange(location: 0, length: textStorage.length), at: .zero)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        for (range, rect, url) in interactiveRanges {
            if rect.contains(location) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                break
            }
        }
    }
}
