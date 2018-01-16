//
//  NibTableViewHeaderFooterView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/3/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibTableViewHeaderFooterView: UITableViewHeaderFooterView, NibContainer {
    
    // MARK: - Init
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addContentSubview()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addContentSubview()
    }
    
    // MARK: - UITableViewHeaderFooterView
    
    open override var textLabel: UILabel? {
        return (contentSubview as? TextLabelProvider)?.textLabel
    }
    
}
