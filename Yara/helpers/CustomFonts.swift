//
//  CustomFonts.swift
//  Yara
//

import UIKit

class CustomFont {
    static func regularFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func mediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func lightFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func semiBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func boldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }

    static func extraBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Extrabold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func interMediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Medium", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func sharpMediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SharpGrotesk-Medium25", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func sharpSemiBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SharpGrotesk-SemiBold25", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
}
