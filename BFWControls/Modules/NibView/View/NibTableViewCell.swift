//
//  NibTableViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/3/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

class NibTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addNib()
    }
    
}

extension NibTableViewCell: NibReplaceable {
    
    var nibView: NibView {
        fatalError("nibView must be implemented in subclass")
    }
    
}
