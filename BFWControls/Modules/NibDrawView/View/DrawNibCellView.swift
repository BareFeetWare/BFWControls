//
//  DrawNibCellView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 24/03/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

class DrawNibCellView: NibCellView {

    var iconDrawView: DrawingView? {
        return iconView as? DrawingView
    }
    
    @IBInspectable var iconName: String? {
        get {
            return iconDrawView?.name
        }
        set {
            iconDrawView?.name = newValue
        }
    }

    @IBInspectable var iconStyleKit: String? {
        get {
            return iconDrawView?.styleKit
        }
        set {
            iconDrawView?.styleKit = newValue
        }
    }

    var accessoryDrawView: DrawingView? {
        return accessoryView as? DrawingView
    }
    
    @IBInspectable var accessoryName: String? {
        get {
            return accessoryDrawView?.name
        }
        set {
            accessoryDrawView?.name = newValue
        }
    }
    
    @IBInspectable var accessoryStyleKit: String? {
        get {
            return accessoryDrawView?.styleKit
        }
        set {
            accessoryDrawView?.styleKit = newValue
        }
    }

}
