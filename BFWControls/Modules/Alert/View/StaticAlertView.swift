//
//  StaticAlertView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 1/03/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable class StaticAlertView: NibView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var messageButton0Constraint: NSLayoutConstraint!

    // MARK: - Variables
    
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var message: String? {
        didSet {
            messageLabel.text = message
        }
    }

    @IBInspectable var button0Title: String? {
        didSet {
            button0.setTitle(button0Title, for: UIControlState())
            setNeedsUpdateView()
        }
    }

    @IBInspectable var button1Title: String? {
        didSet {
            button1.setTitle(button1Title, for: UIControlState())
            setNeedsUpdateView()
        }
    }

    // MARK: - NibView
    
    override func updateView() {
        super.updateView()
        button1.isHidden = button1Title == nil
        messageLabel.activateOnlyConstraintsWithFirstVisibleInViews([button1, button0])
    }
    
}
