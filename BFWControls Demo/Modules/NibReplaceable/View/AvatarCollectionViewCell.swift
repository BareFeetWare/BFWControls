//
//  AvatarCollectionViewCell.swift
//  BFWControls Demo
//
//  Created by Andy Kim on 23/7/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit
import BFWControls

@IBDesignable class AvatarCollectionViewCell: NibCollectionViewCell {
    
    // TODO: Incorporate textLabel etc into NibCollectionViewCell, instead of using NibCellView subview.
    var cellView: NibCellView? {
        return contentView.subviews.first { $0 is NibCellView } as? NibCellView
    }
    
    @IBInspectable var text: String? {
        get {
            return cellView?.textLabel?.text
        }
        set {
            cellView?.textLabel?.text = newValue
        }
    }
    
    @IBInspectable var detailText: String? {
        get {
            return cellView?.detailTextLabel?.text
        }
        set {
            cellView?.detailTextLabel?.text = newValue
        }
    }
    
    var imageView: UIImageView? {
        get {
            return cellView?.iconView as? UIImageView
        }
        set {
            cellView?.iconView = newValue
        }
    }
    
    @IBInspectable var image: UIImage? {
        get {
            return imageView?.image
        }
        set {
            imageView?.image = newValue
        }
    }
    
}
