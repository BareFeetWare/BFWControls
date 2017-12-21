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
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    @IBInspectable var message: String? {
        get {
            return messageLabel.text
        }
        set {
            messageLabel.text = newValue
        }
    }

    @IBInspectable var button0Title: String? {
        get {
            return button0.title(for: .normal)
        }
        set {
            button0.setTitle(newValue, for: .normal)
        }
    }

    @IBInspectable var button1Title: String? {
        get {
            return button1.title(for: .normal)
        }
        set {
            button1.setTitle(newValue, for: .normal)
            setNeedsUpdateView()
        }
    }

    // MARK: - NibView
    
    override func updateView() {
        super.updateView()
        button1.isHidden = button1Title == nil
        messageLabel.activateOnlyConstraintsWithFirstVisible(in: [button1, button0])
    }
    
}
