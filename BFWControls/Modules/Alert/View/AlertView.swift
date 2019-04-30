//
//  AlertView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 23/02/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable open class AlertView: NibView {
    
    // MARK: - Structs
    
    fileprivate struct ButtonTitle {
        static let cancel = "Cancel"
        static let ok = "OK"
    }
    
    fileprivate struct Minimum {
        static let height: CGFloat = 50.0
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet open weak var titleLabel: UILabel?
    @IBOutlet open weak var messageLabel: UILabel?
    @IBOutlet open weak var button0: UIButton?
    @IBOutlet open weak var button1: UIButton?
    @IBOutlet open weak var button2: UIButton?
    @IBOutlet open weak var button3: UIButton?
    @IBOutlet open weak var button4: UIButton?
    @IBOutlet open weak var button5: UIButton?
    @IBOutlet open weak var button6: UIButton?
    @IBOutlet open weak var button7: UIButton?
    
    @IBOutlet open var horizontalButtonsLayoutConstraints: [NSLayoutConstraint]?
    @IBOutlet open var verticalButtonsLayoutConstraints: [NSLayoutConstraint]?
    
    // MARK: - Variables
    
    @IBInspectable open var title: String? {
        get {
            return titleLabel?.text
        }
        set {
            titleLabel?.text = newValue
        }
    }
    
    @IBInspectable open var message: String? {
        get {
            return messageLabel?.text
        }
        set {
            messageLabel?.text = newValue
        }
    }
    
    @IBInspectable open var hasCancel: Bool = true {
        didSet {
            setNeedsUpdateView()
        }
    }
    
    @IBInspectable open var button0Title: String? { didSet { setNeedsUpdateView() } }
    @IBInspectable open var button1Title: String? { didSet { setNeedsUpdateView() } }
    @IBInspectable open var button2Title: String? { didSet { setNeedsUpdateView() } }
    @IBInspectable open var button3Title: String? { didSet { setNeedsUpdateView() } }
    @IBInspectable open var button4Title: String? { didSet { setNeedsUpdateView() } }
    @IBInspectable open var button5Title: String? { didSet { setNeedsUpdateView() } }
    @IBInspectable open var button6Title: String? { didSet { setNeedsUpdateView() } }
    @IBInspectable open var button7Title: String? { didSet { setNeedsUpdateView() } }
    
    @IBInspectable open var maxHorizontalButtonTitleCharacterCount: Int = 9 {
        didSet {
            setNeedsUpdateView()
        }
    }
    
    // MARK: - Functions
    
    open func buttonTitle(at index: Int) -> String? {
        let button = buttons[index]
        return button.currentTitle
    }
    
    open func index(of button: UIButton) -> Int? {
        return buttons.firstIndex(of: button)
    }
    
    open func button(forTitle title: String) -> UIButton? {
        return actions.first { $0.title == title }?.button
    }
    
    // MARK: - Private variables and functions
    
    typealias Action = (button: UIButton?, title: String?)
    
    fileprivate var displayedButton0Title: String {
        return button0Title ?? (hasCancel ? ButtonTitle.cancel : ButtonTitle.ok)
    }
    
    fileprivate var bottomActions: [Action] {
        return [
            (button0, displayedButton0Title),
            (button1, button1Title)
        ]
    }
    fileprivate var topActions: [Action] {
        return [
            (button2, button2Title),
            (button3, button3Title),
            (button4, button4Title),
            (button5, button5Title),
            (button6, button6Title),
            (button7, button7Title)
        ]
    }
    
    fileprivate var actions: [Action] {
        return bottomActions + topActions
    }
    
    fileprivate var buttons: [UIButton] {
        return actions.compactMap { $0.button }
    }
    
    fileprivate var isHorizontalLayout: Bool {
        let hasTopTitles = topActions.compactMap { $0.title }.count > 0
        let hasShortBottomTitles = bottomActions.compactMap { action in
            action.title
            }.filter { title in
                title.count <= maxHorizontalButtonTitleCharacterCount
            }.count == 2
        return hasShortBottomTitles && !hasTopTitles
    }
    
    fileprivate func hideUnused() {
        for action in actions {
            action.button?.isHidden = action.title == nil || isPlaceholderString(action.title)
        }
        messageLabel?.activateOnlyConstraintsWithFirstVisible(in: buttons.reversed())
        if let stackView = button0?.superview as? UIStackView {
            stackView.axis = isHorizontalLayout ? .horizontal : .vertical
        } else if let horizontalButtonsLayoutConstraints = horizontalButtonsLayoutConstraints,
            let verticalButtonsLayoutConstraints = verticalButtonsLayoutConstraints
        {
            if isHorizontalLayout {
                NSLayoutConstraint.activate(horizontalButtonsLayoutConstraints)
                NSLayoutConstraint.deactivate(verticalButtonsLayoutConstraints)
            } else {
                NSLayoutConstraint.activate(verticalButtonsLayoutConstraints)
                NSLayoutConstraint.deactivate(horizontalButtonsLayoutConstraints)
            }
        }
    }
    
    // MARK: - UIView
    
    // Override NibView which copies size from xib. Forces calculation using contents.
    open override var intrinsicContentSize : CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Minimum.height)
    }
    
    open override func layoutSubviews() {
        hideUnused()
        super.layoutSubviews()
    }
    
    // MARK: - NibView
    
    open override var placeholderViews: [UIView] {
        return [titleLabel, messageLabel].compactMap { $0 }
    }
    
    open override func updateView() {
        super.updateView()
        for action in actions {
            action.button?.setTitle(action.title, for: .normal)
        }
    }
    
}
