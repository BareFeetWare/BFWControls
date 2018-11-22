//
//  NibCellViewContainer.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 22/10/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

public protocol NibCellViewContainer {
    
    var cellView: NibCellView? { get }
    
}

extension UITableViewCell: NibCellViewContainer {
    
    @objc public var cellView: NibCellView? {
        return contentView.subviews.first { $0 is NibCellView } as? NibCellView
    }
    
}
