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
            // TODO: Reverse engineer angle from transform.
            return 0.0
        }
        set {
            transform = CGAffineTransform(rotationAngle: CGFloat(M_PI) / 180.0 * newValue)
        }
    }
    
}
