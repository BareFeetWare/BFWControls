//
//  Shadable.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 24/6/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//

import UIKit

public protocol Shadable {
    
    // Declare these variables as stored @IBInspectable to set per instance:
    
    var isLight: Bool { get }
    var isLightAuto: Bool { get }
    var isLightUse: Bool { get }

    var shadeLevel: Int { get }
    var lightColors: [UIColor] { get }
    var darkColors: [UIColor] { get }
    
    // Implemented by extension:
    
//    func applyShade()
    
}

public extension Shadable where Self: UIView {
    
    var shadeLevel: Int {
        get {
            return 0
        }
        set {
            fatalError("Shadable priority set not implemented")
        }
    }
    
    var lightColors: [UIColor] {
        get {
            return [.white, .lightGray, .gray, .darkGray, .black]
        }
        set {
            fatalError("Shadable lightColors set not implemented")
        }
    }
    
    var darkColors: [UIColor] {
        get {
            return lightColors.reversed()
        }
        set {
            fatalError("Shadable darkColors set not implemented")
        }
    }
    
    var isLight: Bool {
        return false
    }
    
    var isLightAuto: Bool {
        return true
    }
    
    var isLightUse: Bool {
        return isLightAuto
            ? (superview as? Shadable)?.isLightUse
                ?? isBackgroundLight.map { !$0 }
                ?? isLight
            : isLight
    }
    
    var shadeColor: UIColor {
        let colors = isLight
            ? lightColors
            : darkColors
        let index = max(shadeLevel, colors.count - 1)
        let color = colors[index]
        return color
    }
    
//    func applyShade() {
//        subviews.forEach {
//            ($0 as? Shadable)?.applyShade()
//        }
//    }
    
}

//extension Shadable where Self: UILabel {
//    
//    func applyShade() {
//        textColor = shadeColor
//    }
//    
//}

fileprivate extension UIView {
    
    struct Threshold {
        static let alpha: CGFloat = 0.5
        static let white: CGFloat = 0.8
        static let black: CGFloat = 0.2
    }
    
    /// Color that shows through background of the view. Recursively checks superview if view background is clear.
    var visibleBackgroundColor: UIColor? {
        get {
            var color: UIColor?
            var superview: UIView? = self
            while superview != nil {
                if let backgroundColor = superview?.backgroundColor {
                    var white: CGFloat = 0.0
                    var alpha: CGFloat = 0.0
                    backgroundColor.getWhite(&white, alpha: &alpha)
                    if alpha > Threshold.alpha {
                        color = backgroundColor
                        break
                    }
                }
                superview = superview!.superview
            }
            return color
        }
    }
    
    /// True if background color is closer to white than black. Recursively checks superview if view background is clear.
    var isBackgroundLight: Bool? {
        var isBackgroundLight: Bool?
        var white: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        if let visibleBackgroundColor = visibleBackgroundColor {
            visibleBackgroundColor.getWhite(&white, alpha: &alpha)
            isBackgroundLight = white > Threshold.white ? true : white < Threshold.black ? false : nil
        }
        return isBackgroundLight
    }
    
}
