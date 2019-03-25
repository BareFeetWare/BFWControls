//
//  NibButton.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 20/11/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

/*
 To use NibButton:
 1. Create your own subclass of NibButton.
 2. Create a xib file, containing a UIView, with the same file name of your subclass.
 3. Set the class of the UIView in your xib to your NibButton subclass.
 4. Connect the outlets titleLabel and imageView to subviews in your xib.
 */

import UIKit

@IBDesignable open class NibButton: BFWNibButton, NibReplaceable {
    
    // MARK: - Variables
    
    @IBInspectable open var intrinsicSize: CGSize = CGSize.zero
    
    // MARK: - NibReplaceable
    
    open var nibName: String?
    
    open var placeholderViews: [UIView] {
        return [titleLabel].compactMap { $0 }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet open override var titleLabel: UILabel? {
        get {
            return overridingTitleLabel ?? super.titleLabel
        }
        set {
            overridingTitleLabel = newValue
        }
    }
    
    @IBOutlet open override var imageView: UIImageView? {
        get {
            return overridingImageView ?? super.imageView
        }
        set {
            overridingImageView = newValue
        }
    }
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    /// Convenience called by init(frame:) and init(coder:). Override in subclasses if required.
    open func commonInit() {
    }
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        guard let nibView = replacedByNibView()
            else { return self }
        nibView.copySubviewProperties(from: self)
        // Pass through taps to the button, not intercepted by subviews:
        nibView.subviews.forEach { $0.isUserInteractionEnabled = false }
        nibView.isNibReplacement = true
        return nibView
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToWindow()
        updateForCurrentState()
    }
    
    // MARK: - Private variables
    
    private var overridingTitleLabel: UILabel?
    private var overridingImageView: UIImageView?
    private var titleForState: [UInt : String] = [:]
    private var attributedTitleForState: [UInt : NSAttributedString] = [:]
    private var imageForState: [UInt : UIImage] = [:]
    private var isNibReplacement = false
    
    // MARK: - Functions
    
    private func overridingTitle(for state: UIControl.State) -> String? {
        return titleForState[state.rawValue] ?? titleForState[UIControl.State.normal.rawValue]
    }
    
    private func overridingAttributedTitle(for state: UIControl.State) -> NSAttributedString? {
        return attributedTitleForState[state.rawValue] ?? attributedTitleForState[UIControl.State.normal.rawValue]
    }
    
    private func overridingImage(for state: UIControl.State) -> UIImage? {
        return imageForState[state.rawValue] ?? imageForState[UIControl.State.normal.rawValue]
    }
    
    private func updateForCurrentState() {
        if let title = overridingAttributedTitle(for: state) {
            titleLabel?.attributedText = title
        } else if let title = overridingTitle(for: state) {
            titleLabel?.text = title
        }
        titleLabel?.textColor = titleColor(for: state)
        titleLabel?.shadowColor = titleShadowColor(for: state)
        if let image = overridingImage(for: state) {
            imageView?.image = image
        }
    }
    
    // MARK: - UIButton overrides
    
    open override var isHighlighted: Bool {
        didSet {
            updateForCurrentState()
        }
    }
    
    open override var isSelected: Bool {
        didSet {
            updateForCurrentState()
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            updateForCurrentState()
        }
    }
    
    open override func title(for state: UIControl.State) -> String? {
        return isNibReplacement
            ? overridingTitle(for: state)
            : super.title(for: state)
    }
    
    open override func attributedTitle(for state: UIControl.State) -> NSAttributedString? {
        return isNibReplacement
            ? overridingAttributedTitle(for: state)
            : super.attributedTitle(for: state)
    }
    
    open override func image(for state: UIControl.State) -> UIImage? {
        return isNibReplacement
            ? overridingImage(for: state)
            : super.image(for: state)
    }
    
    open override func setTitle(_ title: String?, for state: UIControl.State) {
        titleForState[state.rawValue] = title
        super.setTitle(nil, for: state)
    }
    
    open override func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) {
        attributedTitleForState[state.rawValue] = title
        super.setAttributedTitle(nil, for: state)
    }
    
    open override func setImage(_ image: UIImage?, for state: UIControl.State) {
        imageForState[state.rawValue] = image
        super.setImage(nil, for: state)
    }
    
    // MARK: - UIView overrides
    
    open override var intrinsicContentSize: CGSize {
        if intrinsicSize != .zero {
            return intrinsicSize
        } else {
            return type(of: self).sizeFromNib ?? .zero
        }
    }
    
    open override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            // If storyboard instance is "default" (nil) then use the backgroundColor already set in xib or awakeFromNib (ie don't set it again).
            if newValue != nil {
                super.backgroundColor = newValue
            }
        }
    }
    
}

@objc public extension NibButton {
    
    @objc func replacedByNibViewForInit() -> Self? {
        return replacedByNibView()
    }
    
}
