//
//  UIView+Table.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 4/08/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension UIView {
    
    var superviewCell: UITableViewCell? {
        return self as? UITableViewCell ?? superview?.superviewCell
    }
    
    // TODO: Consolidate with superviewCell using generics.
    var superviewTableView: UITableView? {
        return self as? UITableView ?? superview?.superviewTableView
    }
    
    func updateTableViewCellHeights() {
        if let tableView = superviewTableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

}
