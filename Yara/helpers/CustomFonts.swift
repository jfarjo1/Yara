//
//  CustomFonts.swift
//  Yara
//

import UIKit
import Foundation

class CustomFont {
    static func regularFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Regular", size: size.scaled()) ?? UIFont.systemFont(ofSize: size.scaled())
    }

    static func mediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Medium", size: size.scaled()) ?? UIFont.systemFont(ofSize: size.scaled())
    }

    static func lightFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Light", size: size.scaled()) ?? UIFont.systemFont(ofSize: size.scaled())
    }

    static func semiBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Semibold", size: size.scaled()) ?? UIFont.systemFont(ofSize: size.scaled())
    }

    static func boldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Bold", size: size.scaled()) ?? UIFont.boldSystemFont(ofSize: size.scaled())
    }

    static func extraBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Extrabold", size: size.scaled()) ?? UIFont.boldSystemFont(ofSize: size.scaled())
    }
    
    static func interMediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Medium", size: size.scaled()) ?? UIFont.boldSystemFont(ofSize: size.scaled())
    }
    
    static func sharpMediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SharpGrotesk-Medium25", size: size.scaled()) ?? UIFont.boldSystemFont(ofSize: size.scaled())
    }
    
    static func sharpSemiBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SharpGrotesk-SemiBold25", size: size) ?? UIFont.boldSystemFont(ofSize: size.scaled())
    }
    
}

extension CGFloat {
    func scaled() -> CGFloat {
        let baseDeviceWidth: CGFloat = 393.0  // iPhone 16 Pro width
        let currentDeviceWidth = UIScreen.main.bounds.width
        let ratio = currentDeviceWidth / baseDeviceWidth
        
        // Limit scaling between 0.8 and 1.2 of original size
        let minRatio: CGFloat = 0.8
        let maxRatio: CGFloat = 1.2
        let boundedRatio = Swift.min(Swift.max(ratio, minRatio), maxRatio)
        
        return self * boundedRatio
    }
}
