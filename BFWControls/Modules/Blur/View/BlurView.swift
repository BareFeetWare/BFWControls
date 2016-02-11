//
//  BlurView.swift
//
//  Created by Tom Brodhurst-Hill on 13/10/2015.
//  Copyright (c) 2015 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

class BlurView: UIView {

    @IBInspectable var blurRadius: CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    //MARK: Accessors

    var blurredImage: UIImage? {
        var blurredImage: UIImage? = nil;
        if let subviews = superview?.subviews,
            selfIndex = subviews.indexOf(self) {
            if selfIndex > 0 {
                let previousView = subviews[selfIndex - 1];
                let contentImage = UIImage(ofView: previousView,
                                           size: bounds.size)
                blurredImage = UIImageEffects.imageByApplyingBlurToImage(contentImage,
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
    override func drawRect(_: CGRect) {
        if let image = blurredImage {
            image.drawInRect(bounds)
        }
    }
    #endif
}

