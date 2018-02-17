//
//  UITableViewCell+Separator.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 12/12/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

/// To see the change in the storyboard, you must use a UITabelViewCell subclass that has @IBDesignable, such as DesignableTableViewCell.
public extension UITableViewCell {
    
    /// Arbitrarily large number. Must be larger than any possible screen dimension. Can't be .greatestFiniteMagnitude, since that causes a screen flash when the app is restored from background.
    private var hiddenInsetRight: CGFloat {
        return 999999.0
    }

    /// Hides the separator in a cell in a table view that is showing cell separators.
    @IBInspectable public var isSeparatorHidden: Bool {
        get {
            return separatorInset.right == hiddenInsetRight
        }
        set {
            guard let insetRight: CGFloat = newValue
                ? hiddenInsetRight
                : superviewTableView?.separatorInset.right
                else { return }
            separatorInset.right = insetRight
        }
    }
    
}
