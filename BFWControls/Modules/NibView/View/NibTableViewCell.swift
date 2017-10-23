//
//  NibTableViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/3/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibTableViewCell: UITableViewCell {
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addNib()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addNib()
    }
    
}

extension NibTableViewCell: NibReplaceable {
    
    public var nibView: NibView {
        fatalError("nibView must be implemented in subclass")
    }
    
}
