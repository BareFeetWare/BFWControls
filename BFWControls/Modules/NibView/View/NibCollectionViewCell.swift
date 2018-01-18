//
//  NibCollectionViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 14/8/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibCollectionViewCell: UICollectionViewCell {
    
    // MARK: - NibView container
    
    private func addContentSubview() {
        contentView.addSubview(nibView)
        nibView.pinToSuperviewEdges()
    }
    
    open var nibView: NibView {
        fatalError("Concrete subclass must provide nibView.")
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    open func commonInit() {
        addContentSubview()
    }
    
}
