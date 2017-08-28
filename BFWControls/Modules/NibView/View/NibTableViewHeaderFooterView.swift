//
//  NibTableViewHeaderFooterView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/3/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    // MARK: - Init
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addNib()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addNib()
    }
    
    // MARK: - UITableViewHeaderFooterView
    
    open override var textLabel: UILabel? {
        return (nibView as? Interchangeable)?.textLabel
    }
    
}

extension NibTableViewHeaderFooterView: NibReplaceable {
    
    open var nibView: NibView {
        fatalError("nibView must be implemented in subclass")
    }
    
}
