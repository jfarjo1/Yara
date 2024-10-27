//
//  UIView+extension.swift
//  Yara
//
//  Created by Johnny Owayed on 13/10/2024.
//

import UIKit

extension UIView {
    
    @objc func setRounded() {
        layer.cornerRadius = (frame.width / 2) // instead of let radius = CGRectGetWidth(self.frame) / 2
        layer.masksToBounds = true
    }
    
    func popIn(duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.alpha = 0.0
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func popOut(duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.alpha = 0.0
        }, completion: { finished in
            self.isHidden = true
            self.transform = CGAffineTransform.identity
            completion?(finished)
        })
    }
    
    func popInOut(inDuration: TimeInterval = 0.3, outDuration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        self.popIn(duration: inDuration, delay: delay) { finished in
            guard finished else { return }
            self.popOut(duration: outDuration, delay: delay, completion: completion)
        }
    }

    public func addViewBorder(borderColor: CGColor, borderWidth: CGFloat, borderCornerRadius: CGFloat) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
        layer.cornerRadius = borderCornerRadius
    }

    func dropShadow(offsetX: CGFloat, offsetY: CGFloat, color: UIColor, opacity: Float, radius: CGFloat, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func applyShadow(color: UIColor? = .black,
                     alpha: Float,
                     offsetX: CGFloat,
                     offsetY: CGFloat,
                     blur: CGFloat,
                     spread: CGFloat = 0,
                     backgroundColor: UIColor = .white) {
        layer.shadowOpacity = alpha
        layer.shadowColor = color?.cgColor
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowRadius = blur / 2
        
//        let backgroundCGColor = backgroundColor.cgColor
//        let shadowPath = UIBezierPath(rect: bounds.insetBy(dx: -spread, dy: -spread))
//        layer.shadowPath = shadowPath.cgPath
//        layer.backgroundColor = backgroundCGColor
        

    }
    
    func addLightShadow(
            color: UIColor = .black,
            opacity: Float = 0.03,
            offset: CGSize = CGSize(width: 0, height: 2),
            radius: CGFloat = 4,
            cornerRadius: CGFloat = 20
        ) {
            layer.masksToBounds = false
            layer.shadowColor = color.cgColor
            layer.shadowOpacity = opacity
            layer.shadowOffset = offset
            layer.shadowRadius = radius
            layer.cornerRadius = cornerRadius
            
            // Optimize shadow rendering
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
    
    func imageWithView() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func addDashedBorder() {
        let color = UIColor.init(hex: "F5F5F5")?.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: CGColor) -> CALayer {
            let borderLayer = CAShapeLayer()

            borderLayer.strokeColor = color
            borderLayer.lineDashPattern = pattern
            borderLayer.frame = bounds
            borderLayer.fillColor = nil
            borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath

            layer.addSublayer(borderLayer)
            return borderLayer
        }
}

//
//  Extensions.swift
//  Simly
//

import SwiftMessages

import UIKit

extension UIViewController {
    func showToast(_ theme: Theme, _ toastTitle: String, _ toastBody: String, _ icons: [String]) {
        TapticEngine.impact.feedback(.medium)
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(theme)
        let iconText = icons.randomElement()!
        warning.configureContent(title: toastTitle, body: toastBody, iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
    }
    
    func toMain(index: Int) {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return
        }
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        vc.selectedIndex = index
        window.rootViewController = vc

        let options: UIView.AnimationOptions = .transitionCrossDissolve

        let duration: TimeInterval = 0.3

        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
        { completed in})
    }
    
    func toWelcome() {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return
        }
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "WelcomeNav")
        window.rootViewController = vc

        let options: UIView.AnimationOptions = .transitionCrossDissolve

        let duration: TimeInterval = 0.3

        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
        { completed in})
    }
    

    // Make sure from which uiviewcontroller it is called must have segue toWelcome
    func userLoggedOut() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        
        LocalStorageManager().removeLocalUser()
        
        self.toWelcome()
    }
}

extension UIResponder {
    func getOwningViewController() -> UIViewController? {
        var nextResponser = self
        while let next = nextResponser.next {
            nextResponser = next
            if let viewController = nextResponser as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension Double {
    func epochToDateAsString() -> String {
        let epochTime = TimeInterval(self) / 1000
        let date = Date(timeIntervalSince1970: epochTime)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        let localDate = dateFormatter.string(from: date)
        return localDate
    }

    func epochToDate() -> Date {
        let epochTime = TimeInterval(self) / 1000
        let date = Date(timeIntervalSince1970: epochTime)
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US")
//        dateFormatter.dateStyle = .medium
//        let localDate = dateFormatter.string(from: date)
        return date
    }
}

extension String {
    var localized: String {
        return LocalizationSystem.sharedInstance.localizedStringForKey(key: self, comment: "")
    }

    func toUInt() -> UInt? {
        let scanner = Scanner(string: self)
        var u: UInt64 = 0
        if scanner.scanUnsignedLongLong(&u) && scanner.isAtEnd {
            return UInt(u)
        }
        return nil
    }

    func trim() -> String {
        return trimmingCharacters(in: NSCharacterSet.whitespaces)
    }

    func isValidUsername() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^([a-z0-9]){1,22}$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }

    func stringToDate(dateFormat: String, dateStyle: DateFormatter.Style) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.dateFormat = dateFormat

        if let date = dateFormatter.date(from: self) {
            print(date)
            return date
        }
        return nil
    }
}

extension Date {
    public var removeTimeStamp: Date? {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return nil
        }
        return date
    }

    public func addDaysToDate(numberOfDays: Int) -> Date? {
        var dayComponent = DateComponents()
        dayComponent.day = numberOfDays
        let newDate = Calendar.current.date(byAdding: dayComponent, to: self)
        return newDate
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hexStringSafe = hexString.replacingOccurrences(of: "#", with: "")
        if let rgbValue = UInt(hexStringSafe, radix: 16) {
            let red = CGFloat((rgbValue >> 16) & 0xFF) / 255
            let green = CGFloat((rgbValue >> 8) & 0xFF) / 255
            let blue = CGFloat(rgbValue & 0xFF) / 255
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
}

extension UITextField {
    override open func awakeFromNib() {
//        super.awakeFromNib()
//        let language = LanguageManager.shared.currentLanguage()
//        if language .contains("ar") {
//            if textAlignment == .natural || textAlignment == .left {
//                textAlignment = .right
//            }
//        } else {
//            if textAlignment == .natural || textAlignment == .right {
//                textAlignment = .left
//            }
//        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UILabel {
//    override open func awakeFromNib() {
//        super.awakeFromNib()
//        let language = LanguageManager.shared.currentLanguage()
//        if language .contains("ar") {
//            if textAlignment == .natural || textAlignment == .left {
//                textAlignment = .right
//            }
//        }
//    }
}

extension UIImageView {
    func loadImage(url: String) {
//        let imageURL = URL(string: url)!
//        kf.setImage(with: imageURL)
    }
}

// extension UIImageView {
//
//    @IBInspectable public var flippedHorizontally: UIImageView {
//        if let image = self.image {
//            self.image = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .upMirrored)
//        }
//        return self
//    }
//
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
//            self.image = self.image?.flippedHorizontally(enable: true)
//        } else {
//            self.image = self.image?.flippedHorizontally(enable: false)
//        }
//    }
// }
// extension UIImage {
//    public func flippedHorizontally(enable: Bool) -> UIImage {
//        return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: enable ? .upMirrored : .leftMirrored)
//    }
// }

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
