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
    
    @IBInspectable var iconImage: UIImage? {
        get {
            let image: UIImage?
            if let imageView = iconView as? UIImageView {
                image = imageView.image
            } else {
                image = nil
            }
            return image
        }
        set {
            if let imageView = iconView as? UIImageView {
                imageView.image = newValue
            }
        }
    }

    @IBInspectable var accessoryImage: UIImage? {
        get {
            let image: UIImage?
            if let imageView = accessoryView as? UIImageView {
                image = imageView.image
            } else {
                image = nil
            }
            return image
        }
        set {
            if let imageView = accessoryView as? UIImageView {
                imageView.image = newValue
            }
        }
    }
    
}
