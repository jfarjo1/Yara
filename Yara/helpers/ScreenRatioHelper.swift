//
//  ScreenRatioHelper.swift
//  Yara
//
//  Created by Johnny Owayed on 26/11/2024.
//

import UIKit

class ScreenRatioHelper {
    // Base screen size (iPhone 16 Pro dimensions)
    static let baseScreenHeight: CGFloat = 852.0
    static let baseScreenWidth: CGFloat = 393.0
    
    // Get current screen dimensions
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Calculate height ratio compared to base screen
    static var heightRatio: CGFloat {
        return screenHeight / baseScreenHeight
    }
    
    // Adjust a height value based on screen ratio
    static func adjustedHeight(_ height: CGFloat) -> CGFloat {
        return height * heightRatio
    }
    
    // Get percentage of screen height
    static func heightPercentage(_ percentage: CGFloat) -> CGFloat {
        return screenHeight * (percentage / 100)
    }
}
