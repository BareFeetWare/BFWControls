//
//  BlurView.swift
//
//  Created by Tom Brodhurst-Hill on 13/10/2015.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class BlurView: UIView {
    
    @IBInspectable open var blurRadius: CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //MARK: Accessors
    
    open var blurredImage: UIImage? {
        var blurredImage: UIImage? = nil;
        if let subviews = superview?.subviews,
            let selfIndex = subviews.index(of: self) {
            if selfIndex > 0 {
                let previousView = subviews[selfIndex - 1];
                let contentImage = UIImage(of: previousView,
                                           size: bounds.size)
                blurredImage = UIImageEffects.imageByApplyingBlur(to: contentImage,
                                                                  withRadius: blurRadius,
                                                                  tintColor: backgroundColor,
                                                                  saturationDeltaFactor: 1.8,
                                                                  maskImage: nil)
            }
        }
        return blurredImage
    }
    
    //MARK: UIView
    
    #if TARGET_INTERFACE_BUILDER
    // Dont draw anything, so it is transparent.
    #else
    open override func draw(_: CGRect) {
        if let image = blurredImage {
            image.draw(in: bounds)
        }
    }
    #endif
}

