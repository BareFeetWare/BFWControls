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
    
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    var borderColor: UIColor? {
        get {
            var color: UIColor?
            if let layerBorderColor = layer.borderColor {
                color = UIColor(CGColor: layerBorderColor)
            }
            return color
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }
    
    var shadowColor: UIColor? {
        get {
            var color: UIColor?
            if let layerColor = layer.shadowColor {
                color = UIColor(CGColor: layerColor)
            }
            return color
        }
        set {
            layer.shadowColor = newValue?.CGColor
        }
    }
    
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
}