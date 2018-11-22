//
//  NibButton.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 20/11/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable open class NibButton: BFWNibButton, NibReplaceable {
    
    // MARK: - Variables
    
    @IBInspectable open var intrinsicSize: CGSize = CGSize.zero
    
    // MARK: - NibReplaceable
    
    @IBInspectable open var nibName: String?
    
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
        nibView.removePlaceholders()
        return nibView
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Private variables
    
    private var overridingTitleLabel: UILabel?
    private var overridingImageView: UIImageView?
    
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
