//
//  NibCellView.swift
//
//  Created by Tom Brodhurst-Hill on 18/03/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibCellView: NibView, TextLabelProvider {
    
    // MARK: - IBOutlets
    
    @IBOutlet open weak var textLabel: UILabel?
    @IBOutlet open weak var detailTextLabel: UILabel?
    @IBOutlet open weak var iconView: UIView?
    @IBOutlet open weak var accessoryView: UIView?
    @IBOutlet open weak var separatorView: UIView?
    
    // MARK: - Variables and functions
    
    @IBInspectable open var text: String? {
        get {
            return textLabel?.text
        }
        set {
            textLabel?.text = newValue
        }
    }
    
    @IBInspectable open var detailText: String? {
        get {
            return detailTextLabel?.text
        }
        set {
            detailTextLabel?.text = newValue
        }
    }
    
    fileprivate var accessoryConstraints = [NSLayoutConstraint]()
    
    @IBInspectable open var showAccessory: Bool {
        get {
            return !(accessoryView?.isHidden ?? true)
        }
        set {
            guard let accessoryView = accessoryView else { return }
            accessoryView.isHidden = !newValue
            if newValue {
                NSLayoutConstraint.activate(accessoryConstraints)
            } else {
                if let siblingAndSuperviewConstraints = accessoryView.siblingAndSuperviewConstraints,
                    !siblingAndSuperviewConstraints.isEmpty
                {
                    accessoryConstraints = siblingAndSuperviewConstraints
                    NSLayoutConstraint.deactivate(accessoryConstraints)
                }
            }
        }
    }

    // Deprecated. Use table view separators instead.
    @IBInspectable open var showSeparator: Bool {
        get {
            return !(separatorView?.isHidden ?? true)
        }
        set {
            separatorView?.isHidden = !newValue
        }
    }
    
    // MARK: - NibReplaceable
    
    open override var placeholderViews: [UIView] {
        return [textLabel, detailTextLabel].compactMap { $0 }
    }
    
}
