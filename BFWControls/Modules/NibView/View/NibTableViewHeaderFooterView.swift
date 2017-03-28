//
//  NibTableViewHeaderFooterView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/3/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

class NibTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addNib()
    }
    
}

extension NibTableViewHeaderFooterView: NibReplaceable {
    
    var nibView: NibView {
        fatalError("nibView must be implemented in subclass")
    }
    
}
