//
//  UITextField+extension.swift
//  Yara
//
//  Created by Johnny Owayed on 20/10/2024.
//

import UIKit

extension UITextField {
    
    func addDottedBorder(
            color: UIColor = .black,
            lineWidth: CGFloat = 1.0,
            cornerRadius: CGFloat = 8.0,
            dashPattern: [NSNumber] = [4, 4]
        ) {
            // Remove any existing border layers
            layer.sublayers?.forEach { layer in
                if layer is CAShapeLayer {
                    layer.removeFromSuperlayer()
                }
            }
            
            // Create a CAShapeLayer
            let borderLayer = CAShapeLayer()
            
            // Create a path for the border with corner radius
            // Adjust the rect to account for the line width
            let pathRect = bounds.insetBy(dx: lineWidth/2, dy: lineWidth/2)
            let path = UIBezierPath(
                roundedRect: pathRect,
                cornerRadius: cornerRadius
            )
            
            // Configure the border appearance
            borderLayer.path = path.cgPath
            borderLayer.strokeColor = color.cgColor
            borderLayer.lineDashPattern = dashPattern
            borderLayer.lineWidth = lineWidth
            borderLayer.fillColor = nil
            
            // Important: Set frame to bounds
            borderLayer.frame = bounds
            
            // Make sure the border follows the corner radius
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            
            // Add the border layer
            layer.addSublayer(borderLayer)
            
            // Set border layer name for identification
            borderLayer.name = "DottedBorder"
        }
        
        // Method to update border when frame changes
        func updateDottedBorder() {
            guard let borderLayer = layer.sublayers?.first(where: { $0.name == "DottedBorder" }) as? CAShapeLayer else { return }
            
            // Update the path with the new bounds
            let pathRect = bounds.insetBy(dx: borderLayer.lineWidth/2, dy: borderLayer.lineWidth/2)
            let path = UIBezierPath(
                roundedRect: pathRect,
                cornerRadius: layer.cornerRadius
            )
            
            // Update the layer
            borderLayer.path = path.cgPath
            borderLayer.frame = bounds
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
