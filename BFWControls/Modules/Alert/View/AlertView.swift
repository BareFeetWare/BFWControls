//
//  AlertView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 23/02/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable class AlertView: NibView {

    // MARK: - Structs

    private struct ButtonTitle {
        static let cancel = "Cancel"
        static let ok = "OK"
    }
    
    private struct Minimum {
        static let height: CGFloat = 50.0
    }

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var button0: UIButton?
    @IBOutlet weak var button1: UIButton?
    @IBOutlet weak var button2: UIButton?
    @IBOutlet weak var button3: UIButton?
    @IBOutlet weak var button4: UIButton?
    @IBOutlet weak var button5: UIButton?
    @IBOutlet weak var button6: UIButton?
    @IBOutlet weak var button7: UIButton?

    @IBOutlet var horizontalButtonsLayoutConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalButtonsLayoutConstraints: [NSLayoutConstraint]?
    
    // MARK: - Variables

    @IBInspectable var title: String? {
        didSet {
            titleLabel?.text = title
        }
    }
    
    @IBInspectable var message: String? {
        didSet {
            messageLabel?.text = message
        }
    }
    
    @IBInspectable var hasCancel: Bool = true {
        didSet {
            setNeedsUpdateView()
        }
    }
    
    @IBInspectable var button0Title: String? { didSet { setNeedsUpdateView() } }
    @IBInspectable var button1Title: String? { didSet { setNeedsUpdateView() } }
    @IBInspectable var button2Title: String? { didSet { setNeedsUpdateView() } }
    @IBInspectable var button3Title: String? { didSet { setNeedsUpdateView() } }
    @IBInspectable var button4Title: String? { didSet { setNeedsUpdateView() } }
    @IBInspectable var button5Title: String? { didSet { setNeedsUpdateView() } }
    @IBInspectable var button6Title: String? { didSet { setNeedsUpdateView() } }
    @IBInspectable var button7Title: String? { didSet { setNeedsUpdateView() } }
    
    @IBInspectable var maxHorizontalButtonTitleCharacterCount: Int = 9 {
        didSet {
            setNeedsUpdateView()
        }
    }
    
    // MARK: - Functions
    
    func buttonTitleAtIndex(index: Int) -> String? {
        let button = buttons[index]
        return button.currentTitle
    }
    
    func indexOfButton(button: UIButton) -> Int? {
        return buttons.indexOf(button)
    }
    
    // MARK: - Private variables and functions

    typealias Action = (button: UIButton?, title: String?)
    
    private var displayedButton0Title: String {
        return button0Title ?? (hasCancel ? ButtonTitle.cancel : ButtonTitle.ok)
    }
    
    private var bottomActions: [Action] {
        return [
            (button0, displayedButton0Title),
            (button1, button1Title)
        ]
    }
    private var topActions: [Action] {
        return [
            (button2, button2Title),
            (button3, button3Title),
            (button4, button4Title),
            (button5, button5Title),
            (button6, button6Title),
            (button7, button7Title)
        ]
    }
    
    private var actions: [Action] {
        return bottomActions + topActions
    }
    
    private var buttons: [UIButton] {
        return actions.flatMap { $0.button }
    }
    
    private var isHorizontalLayout: Bool {
        let hasTopTitles = topActions.flatMap { $0.title }.count > 0
        let hasShortBottomTitles = bottomActions.flatMap { action in
            action.title
            }.filter { title in
                title.characters.count <= maxHorizontalButtonTitleCharacterCount
            }.count == 2
        return hasShortBottomTitles && !hasTopTitles
    }
    
    private func hideUnused() {
        for action in actions {
            action.button?.hidden = action.title == nil || isPlaceholderString(action.title)
        }
        messageLabel?.activateOnlyConstraintsWithFirstVisibleInViews(buttons.reverse())
        if let horizontalButtonsLayoutConstraints = horizontalButtonsLayoutConstraints,
            let verticalButtonsLayoutConstraints = verticalButtonsLayoutConstraints
        {
            if isHorizontalLayout {
                NSLayoutConstraint.activateConstraints(horizontalButtonsLayoutConstraints)
                NSLayoutConstraint.deactivateConstraints(verticalButtonsLayoutConstraints)
            } else {
                NSLayoutConstraint.activateConstraints(verticalButtonsLayoutConstraints)
                NSLayoutConstraint.deactivateConstraints(horizontalButtonsLayoutConstraints)
            }
        }
    }
    
    // MARK: - UIView
    
    // Override NibView which copies size from xib. Forces calculation using contents.
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: Minimum.height)
    }
    
    // MARK: - NibView
    
    override var placeholderViews: [UIView]? {
        return [titleLabel, messageLabel].flatMap { $0 }
    }
    
    override func updateView() {
        super.updateView()
        for action in actions {
            action.button?.setTitle(action.title, forState: .Normal)
        }
        hideUnused()
    }
    
}
