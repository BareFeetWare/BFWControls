//
//  DirectNibTableViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 24/4/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable open class DirectNibTableViewCell: CustomTableViewCell {

    // MARK: - Show nib content inside IB instance
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        guard let cell = viewFromNib as? UITableViewCell
            else { return }
        cell.copySubviewProperties(from: self)
        contentView.isHidden = true
        let subview = cell.contentView
        addSubview(subview)
        subview.pinToSuperviewEdges()
    }
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        let view = viewFromNib
        if let cell = view as? UITableViewCell {
            cell.copySubviewProperties(from: self)
        }
        return view
    }
    
}
