//
//  UIViewExtensions.swift
//
//  Created by Tom Brodhurst-Hill on 25/03/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

extension UIView {
    
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
