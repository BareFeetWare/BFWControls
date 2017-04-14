//
//  UIViewMorphExtensions.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 14/02/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension UIView {
    
    public func isMorphable(to view: UIView) -> Bool {
        var isMorphable = false
        if tag != 0 && tag == view.tag {
            isMorphable = true
        } else if view is UILayoutSupport && self is UILayoutSupport {
            if view.frame.origin.equalTo(CGPoint.zero) == frame.origin.equalTo(CGPoint.zero) {
                isMorphable = true
            }
        }
        return isMorphable
    }
    
    public func subview(matching view: UIView) -> UIView? {
        var matchingSubview: UIView?
        if view.tag != 0 {
            matchingSubview = viewWithTag(view.tag)
        } else {
            for subview in subviews {
                if subview.isMorphable(to: view) {
                    matchingSubview = subview
                    break
                }
            }
        }
        return matchingSubview;
    }

}

public extension UILabel {
    
    public override func isMorphable(to view: UIView) -> Bool {
        var isMorphable = super.isMorphable(to: view)
        if !isMorphable {
            if let label = view as? UILabel {
                isMorphable = text == label.text
            }
        }
        return isMorphable
    }
    
}

public extension UIImageView {
    
    public override func isMorphable(to view: UIView) -> Bool {
        var isMorphable = super.isMorphable(to: view)
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
