//
//  NibCollectionViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 14/8/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibCollectionViewCell: BFWNibCollectionViewCell {
    
    // TODO: Move to NibReplaceable:
    
    @objc open func replacedByNibView() -> UIView {
        return replacedByNibView(fromNibNamed: type(of: self).nibName)
    }
}
