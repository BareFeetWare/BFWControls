//
//  NibTableViewHeaderFooterView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/3/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addNib()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addNib()
    }
    
}

extension NibTableViewHeaderFooterView: NibReplaceable {
    
    public var nibView: NibView {
        fatalError("nibView must be implemented in subclass")
    }
    
}
