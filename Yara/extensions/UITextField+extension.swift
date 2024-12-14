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
}

extension UIView {
    func addDottedBorderView(
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
}
