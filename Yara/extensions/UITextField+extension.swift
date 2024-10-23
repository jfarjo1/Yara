//
//  UITextField+extension.swift
//  Yara
//
//  Created by Johnny Owayed on 20/10/2024.
//

import UIKit

extension UITextField {
    
    func addDottedBorder(cornerRadius: CGFloat = 5.0, dotSize: CGFloat = 4, spacing: CGFloat = 4) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor(hex: "#D8D8D8")?.cgColor
        borderLayer.lineDashPattern = [NSNumber(value: Float(dotSize)), NSNumber(value: Float(spacing))]
        borderLayer.fillColor = nil
        borderLayer.lineWidth = 2
        
        // Calculate the frame for the border, leaving space on the right
        let borderFrame = bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -25))
        
        let path = UIBezierPath(roundedRect: borderFrame, cornerRadius: cornerRadius)
        borderLayer.path = path.cgPath
        
        layer.addSublayer(borderLayer)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
    func setRightPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func addUploadButton(padding: CGFloat = 10, buttonWidth: CGFloat = 80, font: UIFont = CustomFont.semiBoldFont(size: 14)) {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth + padding, height: self.frame.size.height))
        
        let uploadButton = UIButton(type: .system)
        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.titleLabel?.font = font
        uploadButton.setTitleColor(.black, for: .normal)
        uploadButton.frame = CGRect(x: padding, y: 0, width: buttonWidth, height: containerView.frame.height)
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        
        containerView.addSubview(uploadButton)
        
        self.rightView = containerView
        self.rightViewMode = .always
    }
    
    @objc private func uploadButtonTapped() {
        // Handle the upload button tap
        print("Upload button tapped")
    }
}
