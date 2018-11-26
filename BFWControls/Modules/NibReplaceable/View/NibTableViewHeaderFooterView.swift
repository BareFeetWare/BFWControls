//
//  NibTableViewHeaderFooterView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/3/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    // MARK: - NibView container
    
    private func addContentSubview() {
        contentView.addSubview(nibView)
        nibView.pinToSuperviewEdges()
    }
    
    open var nibView: NibView {
        fatalError("Concrete subclass must provide nibView.")
    }
    
    // MARK: - Init
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    open func commonInit() {
        addContentSubview()
    }
    
    // MARK: - UITableViewHeaderFooterView
    
    open override var textLabel: UILabel? {
        return (nibView as? TextLabelProvider)?.textLabel
    }
    
}
