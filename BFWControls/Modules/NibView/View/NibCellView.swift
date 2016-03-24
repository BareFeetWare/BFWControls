//
//  NibCellView.swift
//
//  Created by Tom Brodhurst-Hill on 18/03/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

class NibCellView: BFWNibView {

    // MARK: - IBOutlets
    
    @IBOutlet weak var textLabel: UILabel?
    @IBOutlet weak var detailTextLabel: UILabel?
    @IBOutlet weak var iconView: UIView?
    @IBOutlet weak var accessoryView: UIView?

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
            needsUpdateView = true
        }
    }
    
    func updateView() {
        accessoryView?.hidden = !showAccessory
    }
    
    var needsUpdateView = true {
        didSet {
            if needsUpdateView {
                setNeedsLayout()
            }
        }
    }
    
    // MARK: - Private variables and functions
    
    private func updateViewIfNeeded() {
        if needsUpdateView {
            needsUpdateView = false
            updateView()
        }
    }

    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateViewIfNeeded()
    }

}
