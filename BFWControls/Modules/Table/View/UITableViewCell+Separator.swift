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
    
    /// Arbitrarily large number. Must be larger than any possible screen dimension. Can't be .greatestFiniteMagnitude, since that causes screen flash when app is restored from background.
    private static let offScreen: CGFloat = 999999.0

    private static let hiddenInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: offScreen)
    
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
