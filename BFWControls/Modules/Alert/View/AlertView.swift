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

    struct ButtonTitle {
        static let cancel = "Cancel"
        static let ok = "OK"
    }
    
    struct Minimum {
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
    
    @IBInspectable var button0Title: String? {
        didSet {
            setNeedsUpdateView()
        }
    }

    @IBInspectable var button1Title: String? {
        get {
            return button1?.titleForState(.Normal)
        }
        set {
            button1?.setTitle(newValue, forState: .Normal)
            setNeedsUpdateView()
        }
    }

    @IBInspectable var button2Title: String? {
        get {
            return button2?.titleForState(.Normal)
        }
        set {
            button2?.setTitle(newValue, forState: .Normal)
            setNeedsUpdateView()
        }
    }

    @IBInspectable var button3Title: String? {
        get {
            return button3?.titleForState(.Normal)
        }
        set {
            button3?.setTitle(newValue, forState: .Normal)
            setNeedsUpdateView()
        }
    }
    
    @IBInspectable var button4Title: String? {
        get {
            return button4?.titleForState(.Normal)
        }
        set {
            button4?.setTitle(newValue, forState: .Normal)
            setNeedsUpdateView()
        }
    }
    
    @IBInspectable var button5Title: String? {
        get {
            return button5?.titleForState(.Normal)
        }
        set {
            button5?.setTitle(newValue, forState: .Normal)
            setNeedsUpdateView()
        }
    }
    
    @IBInspectable var button6Title: String? {
        get {
            return button6?.titleForState(.Normal)
        }
        set {
            button6?.setTitle(newValue, forState: .Normal)
            setNeedsUpdateView()
        }
    }
    
    @IBInspectable var button7Title: String? {
        get {
            return button7?.titleForState(.Normal)
        }
        set {
            button7?.setTitle(newValue, forState: .Normal)
            setNeedsUpdateView()
        }
    }
    
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

    private var buttons: [UIButton] {
        return [button0, button1, button2, button3, button4, button5, button6, button7].flatMap { $0 }
    }
    
    private var displayedButton0Title: String {
        return button0Title ?? (hasCancel ? ButtonTitle.cancel : ButtonTitle.ok)
    }
    
    private func shouldDisplayButton(button: UIButton) -> Bool {
        let title = button.titleForState(.Normal)
        return title != nil && !title!.isEmpty && !isPlaceholderString(title)
    }
    
    private var isHorizontalLayout: Bool {
        var isHorizontalLayout = false
        let otherButtons = buttons.filter { $0 != button0 && $0 != button1 }
        let hasNoOtherTitles = otherButtons.filter { shouldDisplayButton($0) }.count == 0
        if hasNoOtherTitles {
            if let button1Title = button1Title {
                // TODO: Use total width of characters instead of count.
                if displayedButton0Title.characters.count <= maxHorizontalButtonTitleCharacterCount
                    && button1Title.characters.count <= maxHorizontalButtonTitleCharacterCount
                {
                    isHorizontalLayout = true
                }
            }
        }
        return isHorizontalLayout
    }
    
    private func hideUnused() {
        let forwardButtons = buttons.filter { $0 != button0 }
        for button in forwardButtons {
            let title = button.titleForState(.Normal)
            button.hidden = title == nil || isPlaceholderString(title)
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
        button0?.setTitle(displayedButton0Title, forState: .Normal)
        hideUnused()
    }
    
}
