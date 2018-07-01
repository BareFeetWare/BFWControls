//
//  Shadable.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 24/6/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public protocol Shadable {
    
    func setNeedsUpdateView()
    
    // Declare these variables as stored @IBInspectable to set per instance:
    
    var isLight: Bool { get }
    
    // Can override:
    
    var isLightAuto: Bool { get }
    var isLightUse: Bool { get }
    var parentShadable: Shadable? { get }

    var shadeLevel: Int { get }
    var lightColors: [UIColor] { get }
    var darkColors: [UIColor] { get }
    
//    func applyShade()
    
}

public extension Shadable {
    
    var isLight: Bool {
        return false
    }
    
    var isLightAuto: Bool {
        return true
    }
    
    var isLightUse: Bool {
        return isLightAuto
            ? parentShadable?.isLightUse
                ?? isLight
            : isLight
    }
    
    var parentShadable: Shadable? {
        return nil
    }
    
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
    
    var shadeColor: UIColor {
        let colors = isLightUse
            ? lightColors
            : darkColors
        let index = min(shadeLevel, colors.count - 1)
        let color = colors[index]
        return color
    }
    
}

public extension Shadable where Self: UIView {
    
    var parentShadable: Shadable? {
        return superview as? Shadable
    }
    
    var isLightUse: Bool {
        return isLightAuto
            ? (superview as? Shadable)?.isLightUse
                ?? superview?.isBackgroundLight.map { !$0 }
                ?? isLight
            : isLight
    }
    
}

public extension UIView {
    
    func shadeSubviews() {
        subviews.forEach { subview in
            if let shadable = subview as? Shadable {
                shadable.setNeedsUpdateView()
            } else {
                subview.shadeSubviews()
            }
        }
    }
    
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
        static let light: CGFloat = 0.8
        static let dark: CGFloat = 0.6
    }
    
    /// Color that shows through background of the view. Recursively checks superview if view background is clear.
    var visibleBackgroundColor: UIColor? {
        get {
            var color: UIColor?
            var superview: UIView? = self
            while superview != nil {
                if superview is UIImageView {
                    // TODO: Determine average color of image.
                    color = .darkGray
                    break
                }
                if let backgroundColor: UIColor = superview?.backgroundColor
                    ?? (superview as? UINavigationBar)?.barTintColor
                {
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
            isBackgroundLight =
                white < Threshold.dark
                ? false
                : white > Threshold.light
                ? true
                : nil
        }
        return isBackgroundLight
    }
    
}
