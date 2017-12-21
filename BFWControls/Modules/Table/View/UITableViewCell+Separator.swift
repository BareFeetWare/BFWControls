//
//  UITableViewCell+Separator.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 12/12/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension UITableViewCell {
    
    private static let hiddenInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: .greatestFiniteMagnitude)
    
    private var hiddenInset: UIEdgeInsets {
        return type(of: self).hiddenInset
    }
    
    /// Hides the separator is a cell in a table view that is showing cell separators.
    @IBInspectable public var isSeparatorHidden: Bool {
        get {
            return separatorInset == hiddenInset
        }
        set {
            guard let inset: UIEdgeInsets = newValue
                ? hiddenInset
                : superviewTableView?.separatorInset
                else { return }
            separatorInset = inset
        }
    }
    
}
