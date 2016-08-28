//
//  DrawNibButton.swift
//
//  Created by Tom Brodhurst-Hill on 3/03/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

class DrawNibButton: NibButton {

    // MARK: - Variables
    
    // Override in subclass
    var buttonView: DrawButtonView? {
        return nil
    }
    
    @IBInspectable var iconStyleKit: String? {
        get {
            return iconView?.styleKit
        }
        set {
            iconView?.styleKit = newValue
        }
    }
    
    @IBInspectable var iconName: String? {
        get {
            return iconView?.name
        }
        set {
            iconView?.name = newValue
        }
    }
    
    var iconView: DrawingView? {
        get {
            return buttonView?.iconView
        }
        set {
            buttonView?.iconView = newValue
        }
    }
    
    // MARK: - NibButton
    
    override var contentView: NibView? {
        return buttonView
    }
    
    // MARK: - UIButton
    
    override var titleLabel: UILabel? {
        return buttonView?.titleLabel
    }

}
