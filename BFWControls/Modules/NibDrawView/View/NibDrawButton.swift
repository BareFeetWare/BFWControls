//
//  NibDrawButton.swift
//
//  Created by Tom Brodhurst-Hill on 3/03/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

class NibDrawButton: NibButton {

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
    
    var iconView: BFWDrawView? {
        get {
            return buttonView?.iconView
        }
        set {
            buttonView?.iconView = newValue
        }
    }
    
    // MARK: - NibButton
    
    override var contentView: BFWNibView? {
        return buttonView
    }
    
    // MARK: - UIButton
    
    override var titleLabel: UILabel? {
        return buttonView?.titleLabel
    }

}
