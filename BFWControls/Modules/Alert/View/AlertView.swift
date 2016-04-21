//
//  AlertView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 23/02/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

protocol AlertViewDelegate {
    
    func action0Button(button: UIButton)
    func action1Button(button: UIButton)
    func action2Button(button: UIButton)
    func action3Button(button: UIButton)
    
}

@IBDesignable class AlertView: NibView {

    // MARK: - Structs

    struct ButtonTitle {
        static let cancel = "Cancel"
        static let ok = "OK"
    }

    struct Constant {
        static let maxHorizontalButtonTitleCharacterCount = 9
    }

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var delegate: NSObject?

    @IBOutlet var horizontalButtonsLayoutConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalButtonsLayoutConstraints: [NSLayoutConstraint]?
    
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
    
    @IBInspectable var hasCancel: Bool = true {
        didSet {
            setNeedsUpdateView()
        }
    }
    
    @IBInspectable var button0Title: String? {
        didSet {
            setNeedsUpdateView()
        }
    }

    @IBInspectable var button1Title: String? {
        didSet {
            button1.setTitle(button1Title, forState: .Normal)
            setNeedsUpdateView()
        }
    }

    @IBInspectable var button2Title: String? {
        didSet {
            button2.setTitle(button2Title, forState: .Normal)
            setNeedsUpdateView()
        }
    }

    @IBInspectable var button3Title: String? {
        didSet {
            button3.setTitle(button3Title, forState: .Normal)
            setNeedsUpdateView()
        }
    }

    var protocolDelegate: AlertViewDelegate? {
        // Workaround since Swift won't allow IBOutlet on a protocol.
        return delegate as? AlertViewDelegate
    }
    
    // MARK: - Actions
    
    @IBAction func action0Button(button: UIButton) {
        protocolDelegate?.action0Button(button)
    }
    
    @IBAction func action1Button(button: UIButton) {
        protocolDelegate?.action1Button(button)
    }
    
    @IBAction func action2Button(button: UIButton) {
        protocolDelegate?.action2Button(button)
    }
    
    @IBAction func action3Button(button: UIButton) {
        protocolDelegate?.action3Button(button)
    }
    
    // MARK: - Private variables and functions

    private var isHorizontalLayout: Bool {
        var isHorizontalLayout = false
        if button2Title == nil && button3Title == nil {
            if let button0Title = button0Title,
                let button1Title = button1Title
                // TODO: Use total width of characters instead of count.
                where button0Title.characters.count <= Constant.maxHorizontalButtonTitleCharacterCount
                    && button1Title.characters.count <= Constant.maxHorizontalButtonTitleCharacterCount
            {
                isHorizontalLayout = true
            }
        }
        return isHorizontalLayout
    }
    
    private func hideUnused() {
        button1.hidden = button1Title == nil
        button2.hidden = button2Title == nil
        button3.hidden = button3Title == nil
        messageLabel.activateOnlyConstraintsWithFirstVisibleInViews([button3, button2, button1, button0])
        if let horizontalButtonsLayoutConstraints = horizontalButtonsLayoutConstraints,
            let verticalButtonsLayoutConstraints = verticalButtonsLayoutConstraints {
            if isHorizontalLayout {
                NSLayoutConstraint.activateConstraints(horizontalButtonsLayoutConstraints)
                NSLayoutConstraint.deactivateConstraints(verticalButtonsLayoutConstraints)
            } else {
                NSLayoutConstraint.activateConstraints(verticalButtonsLayoutConstraints)
                NSLayoutConstraint.deactivateConstraints(horizontalButtonsLayoutConstraints)
            }
        }
    }
    
    // MARK: - NibView

    override func updateView() {
        super.updateView()
        let buttonTitle = button0Title ?? (hasCancel ? ButtonTitle.cancel : ButtonTitle.ok)
        button0.setTitle(buttonTitle, forState: .Normal)
        hideUnused()
    }
    
}
