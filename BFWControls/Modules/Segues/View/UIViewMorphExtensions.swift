//
//  UIViewMorphExtensions.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 14/02/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

extension UIView {
    
    func isMorphableTo(view: UIView) -> Bool {
        var isMorphable = false
        if tag == view.tag {
            isMorphable = true
        } else if view is UILayoutSupport && self is UILayoutSupport {
            if CGPointEqualToPoint(view.frame.origin, CGPointZero) == CGPointEqualToPoint(frame.origin, CGPointZero) {
                isMorphable = true
            }
        }
        return isMorphable
    }
    
    func subviewMatchingView(view: UIView) -> UIView? {
        var matchingSubview: UIView?
        for subview in subviews {
            if subview.isMorphableTo(view) {
                matchingSubview = subview
                break
            }
        }
        return matchingSubview;
    }

}

extension UILabel {
    
    override func isMorphableTo(view: UIView) -> Bool {
        var isMorphable = super.isMorphableTo(view)
        if !isMorphable {
            if let label = view as? UILabel {
                isMorphable = text == label.text
            }
        }
        return isMorphable
    }
    
}

extension UIImageView {
    
    override func isMorphableTo(view: UIView) -> Bool {
        var isMorphable = super.isMorphableTo(view)
        if !isMorphable {
            if let imageView = view as? UIImageView,
                let image = image
            {
                isMorphable = image.isEqual(imageView.image)
            }
        }
        return isMorphable
    }
    
}