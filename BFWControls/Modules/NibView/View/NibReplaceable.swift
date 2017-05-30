//
//  NibReplaceable.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/3/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

public protocol NibReplaceable {
    
    var nibView: NibView { get }
    var contentView: UIView { get }
    func addNib()
    
}

public extension NibReplaceable {
    
    func addNib() {
        contentView.addSubview(nibView)
        nibView.pinToSuperviewEdges()
    }
    
}
