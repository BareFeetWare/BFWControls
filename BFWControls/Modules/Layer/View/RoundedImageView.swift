//
//  RoundedImageView.swift
//
//  Created by Tom Brodhurst-Hill on 16/11/2015.
//  Copyright © 2015 BareFeetWare. All rights reserved.
//

import UIKit

@IBDesignable open class RoundedImageView: UIImageView {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.size.width / 2, bounds.size.height / 2)
        layer.masksToBounds = true
    }
    
    @IBInspectable open var isBordered: Bool {
        get {
            return layer.borderWidth != 0.0
        }
        set {
            if newValue {
                layer.borderWidth = 3.0
                layer.borderColor = UIColor.white.cgColor
            } else {
                layer.borderWidth = 0.0
                layer.borderColor = nil
            }
        }
    }
    
}
