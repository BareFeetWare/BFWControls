//
//  DrawNibCellView.swift
//  CBA Lego
//
//  Created by Tom Brodhurst-Hill on 24/03/2016.
//  Copyright © 2016 CommBank. All rights reserved.
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

}
