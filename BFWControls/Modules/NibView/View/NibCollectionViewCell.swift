//
//  NibCollectionViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 14/8/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibCollectionViewCell: UICollectionViewCell, NibContainer {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addContentSubview()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addContentSubview()
    }
    
}
