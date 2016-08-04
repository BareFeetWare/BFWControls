//
//  UIView+Table.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 4/08/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

extension UIView {
    
    var superviewCell: UITableViewCell? {
        var result: UITableViewCell?
        var view: UIView? = self
        while view != nil {
            if let possible = view as? UITableViewCell {
                result = possible
                break
            } else {
                view = view?.superview
            }
        }
        return result
    }
    
    // TODO: Consolidate with superviewCell using generics.
    var superviewTableView: UITableView? {
        var result: UITableView?
        var view: UIView? = self
        while view != nil {
            if let possible = view as? UITableView {
                result = possible
                break
            } else {
                view = view?.superview
            }
        }
        return result
    }
    
}
