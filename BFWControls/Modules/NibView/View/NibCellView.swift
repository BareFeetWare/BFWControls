//
//  NibCellView.swift
//
//  Created by Tom Brodhurst-Hill on 18/03/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

@IBDesignable class NibCellView: NibView {

    // MARK: - IBOutlets
    
    @IBOutlet weak var textLabel: UILabel?
    @IBOutlet weak var detailTextLabel: UILabel?
    @IBOutlet weak var iconView: UIView?
    @IBOutlet weak var accessoryView: UIView?
    @IBOutlet weak var separatorView: UIView?

    // MARK: - Variables and functions

    @IBInspectable var text: String? {
        get {
            return textLabel?.text
        }
        set {
            textLabel?.text = newValue
        }
    }
    
    @IBInspectable var detailText: String? {
        get {
            return detailTextLabel?.text
        }
        set {
            detailTextLabel?.text = newValue
        }
    }
    
    @IBInspectable var showAccessory: Bool {
        get {
            return !(accessoryView?.hidden ?? true)
        }
        set {
            accessoryView?.hidden = !newValue
            accessoryView?.deactivateConstraintsIfHidden()
        }
    }
    
    @IBInspectable var showSeparator: Bool {
        get {
            return !(separatorView?.hidden ?? true)
        }
        set {
            separatorView?.hidden = !newValue
        }
    }
    
    // MARK: - NibView
    
    override var placeholderViews: [UIView]? {
        return [textLabel, detailTextLabel].flatMap { $0 }
    }
    
}
