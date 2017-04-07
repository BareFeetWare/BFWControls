//
//  LayerView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 9/01/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

extension UIView {
    
    var rotationDegrees: CGFloat {
        get {
            let angleInRadians = atan2(transform.b, transform.a)
            return angleInRadians * 180.0 / CGFloat(M_PI)
        }
        set {
            transform = CGAffineTransform(rotationAngle: CGFloat(M_PI) / 180.0 * newValue)
        }
    }
    
}
