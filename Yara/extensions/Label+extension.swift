import UIKit

extension UILabel {
    func setGradientTextColor(text: String, font: UIFont, colors: [UIColor]) {
        self.text = text // Set the text
        self.font = font // Set the font
        self.numberOfLines = 3 // Set to 3 lines
        
        // Force layout to ensure correct size
        self.layoutIfNeeded()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        let textLayer = CATextLayer()
        textLayer.frame = bounds
        textLayer.string = text
        textLayer.font = font
        textLayer.fontSize = font.pointSize
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.isWrapped = true // Enable text wrapping

        gradientLayer.mask = textLayer

        layer.sublayers?.forEach { if $0 is CAGradientLayer { $0.removeFromSuperlayer() } }
        layer.addSublayer(gradientLayer)
    }
}
