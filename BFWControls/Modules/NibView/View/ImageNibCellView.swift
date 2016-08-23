//
//  ImageNibCellView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 22/08/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

class ImageNibCellView: NibCellView {
    
    var iconImageView: UIImageView? {
        return iconView as? UIImageView
    }
    
    @IBInspectable var iconImage: UIImage? {
        get {
            return iconImageView?.image
        }
        set {
            iconImageView?.image = newValue
        }
    }

    var accessoryImageView: UIImageView? {
        return accessoryView as? UIImageView
    }
    
    @IBInspectable var accessoryImage: UIImage? {
        get {
            return accessoryImageView?.image
        }
        set {
            accessoryImageView?.image = newValue
        }
    }
    
}
