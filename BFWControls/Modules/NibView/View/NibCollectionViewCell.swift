//
//  NibCollectionViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 14/8/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class NibCollectionViewCell: BFWNibCollectionViewCell {
    
    // TODO: Move to NibReplaceable:
    
    @objc open func replacedByNibView() -> UIView {
        return replacedByNibView(fromNibNamed: type(of: self).nibName)
    }
    
    // MARK: - Init
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        let view = replacedByNibView()
        if view != self {
            (view as? NibReplaceable)?.removePlaceholders()
        }
        return view
    }
    
}
