//
//  NibCollectionViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 14/8/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibCollectionViewCell: BFWNibCollectionViewCell {
    
    /// Override to give different nib for each cell style
    @IBInspectable open var nibName: String?
    
    // TODO: Move to NibReplaceable:
    
    @objc open func replacedByNibView() -> UIView {
        return replacedByNibView(fromNibNamed: nibName ?? type(of: self).nibName)
    }
}
