//
//  NibCollectionViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 14/8/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

class NibCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addNib()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addNib()
    }
    
}

extension NibCollectionViewCell: NibReplaceable {
    
    public var nibView: NibView {
        fatalError("nibView must be implemented in subclass")
    }
    
}

