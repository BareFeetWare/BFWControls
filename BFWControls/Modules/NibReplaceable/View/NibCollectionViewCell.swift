//
//  NibCollectionViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 14/8/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class NibCollectionViewCell: BFWNibCollectionViewCell, NibReplaceable {
    
    // MARK: - Init
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        guard let nibView = replacedByNibView()
            else { return self }
        nibView.removePlaceholders()
        return nibView
    }
    
}

@objc public extension NibCollectionViewCell {
    
    @objc func replacedByNibViewForInit() -> Self? {
        return replacedByNibView()
    }
    
}
