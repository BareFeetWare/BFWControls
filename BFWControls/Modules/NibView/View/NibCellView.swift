//
//  NibCellView.swift
//
//  Created by Tom Brodhurst-Hill on 18/03/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

class NibCellView: NibView {

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
    
    @IBInspectable var showAccessory: Bool = false {
        didSet {
            setNeedsUpdateView()
        }
    }
    
    @IBInspectable var showSeparator: Bool = true {
        didSet {
            setNeedsUpdateView()
        }
    }
    
    // MARK: - NibView
    
    override var placeholderLabels: [UILabel]? {
        return [textLabel, detailTextLabel].flatMap { $0 }
    }
    
    override func updateView() {
        super.updateView()
        accessoryView?.hidden = !showAccessory
        separatorView?.hidden = !showSeparator
    }

    
    
}
