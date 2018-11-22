//
//  ImageNibCellView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 22/08/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class ImageNibCellView: NibCellView {
    
    open var iconImageView: UIImageView? {
        return iconView as? UIImageView
    }
    
    @IBInspectable open var iconImage: UIImage? {
        get {
            return iconImageView?.image
        }
        set {
            iconImageView?.image = newValue
        }
    }
    
    open var accessoryImageView: UIImageView? {
        return accessoryView as? UIImageView
    }
    
    @IBInspectable open var accessoryImage: UIImage? {
        get {
            return accessoryImageView?.image
        }
        set {
            accessoryImageView?.image = newValue
        }
    }
    
}
