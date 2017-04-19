//
//  BlurView.swift
//
//  Created by Tom Brodhurst-Hill on 13/10/2015.
//  Copyright © 2016 BareFeetWare.
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
        guard let subviews = superview?.subviews,
            let previousIndex = subviews.index(of: self).map({ $0 - 1 }),
            subviews.indices.contains(previousIndex)
            else { return nil }
        let contentImage = UIImage.snapshot(of: subviews[previousIndex],
                                            size: bounds.size)
        return UIImageEffects
            .imageByApplyingBlur(to: contentImage,
                                 withRadius: blurRadius,
                                 tintColor: backgroundColor,
                                 saturationDeltaFactor: 1.8,
                                 maskImage: nil)
    }

    //MARK: UIView

    #if TARGET_INTERFACE_BUILDER
    // Dont draw anything, so it is transparent.
    #else
    override func draw(_: CGRect) {
        blurredImage?.draw(in: bounds)
    }
    #endif
}

