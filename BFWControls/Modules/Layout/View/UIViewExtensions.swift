//
//  UIViewExtensions.swift
//
//  Created by Tom Brodhurst-Hill on 25/03/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

extension UIView {
    
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
                    if alpha > 0.5 {
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
            isBackgroundLight = white > 0.5
        }
        return isBackgroundLight
    }
    
}
