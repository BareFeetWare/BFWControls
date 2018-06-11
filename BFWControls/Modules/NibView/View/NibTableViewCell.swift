//
//  NibTableViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 24/4/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable open class NibTableViewCell: BFWNibTableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet open override var textLabel: UILabel? {
        get {
            return activeView(overridingView: overridingTextLabel,
                              inheritedView: super.textLabel ?? UILabel())
                as? UILabel
        }
        set {
            if overridingTextLabel == nil {
                overridingTextLabel = newValue
            }
        }
    }
    
    @IBOutlet open override var detailTextLabel: UILabel? {
        get {
            return activeView(overridingView: overridingDetailTextLabel,
                              inheritedView: inheritedDetailTextLabel ?? UILabel())
                as? UILabel
        }
        set {
            if overridingDetailTextLabel == nil {
                overridingDetailTextLabel = newValue
            }
        }
    }
    
    @IBOutlet open override var imageView: UIImageView? {
        get {
            return activeView(overridingView: overridingImageView,
                              inheritedView: super.imageView)
                as? UIImageView
        }
        set {
            if overridingImageView == nil {
                overridingImageView = newValue
            }
        }
    }
    
    @IBOutlet open var tertiaryTextLabel: UILabel?
    
    @IBInspectable open var tertiaryText: String? {
        get {
            return tertiaryTextLabel?.text
        }
        set {
            tertiaryTextLabel?.text = newValue
        }
    }
    
    // TODO: Perhaps integrate actionView with accessoryView
    
    @IBOutlet open var actionView: UIView?
    
    // MARK: - Private variables
    
    private var overridingTextLabel: UILabel?
    private var overridingDetailTextLabel: UILabel?
    private var overridingImageView: UIImageView?
    
    /// super.detailTextLabel returns nil even though super.textLabel returns the label, so resorting to subviews:
    private var inheritedDetailTextLabel: UILabel? {
        let superLabels = super.contentView.subviews.filter { $0 is UILabel } as! [UILabel]
        let superLabel: UILabel? = super.detailTextLabel
            ?? (
                superLabels.count == 2
                    ? superLabels[1]
                    : nil
        )
        return superLabel
    }
    
    // MARK: - Variables
    
    @IBInspectable open var isActionViewHidden: Bool {
        get {
            return actionView?.isHidden ?? true
        }
        set {
            actionView?.isHidden = newValue
        }
    }
    
    /// Minimum intrinsicContentSize.height to use if the table view uses auto dimension.
    @IBInspectable open var minimumHeight: CGFloat = 0.0
    
    /// Override to give different nib for each cell style
    @IBInspectable open var nibName: String?
    
    open var style: UITableViewCellStyle = .default
    
    open var contentSubview: UIView? {
        guard let contentSubview = contentView.subviews.first,
            contentView.subviews.count == 1
            else { return nil }
        return contentSubview
    }
    
    // MARK: - Functions
    
    private func activeView(overridingView: UIView?, inheritedView: UIView?) -> UIView? {
        #if TARGET_INTERFACE_BUILDER
        return isAwake
            ? overridingView
            : inheritedView
        #else
        return overridingView ?? inheritedView
        #endif
    }
    
    // TODO: Move to NibReplaceable:
    
    @objc open func replacedByNibView() -> UIView {
        return replacedByNibView(fromNibNamed: nibName ?? type(of: self).nibName)
    }
    
    // MARK: - Init
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.style = style
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        let styleInt = coder.decodeInteger(forKey: "UITableViewCellStyle")
        if let style = UITableViewCellStyle(rawValue: styleInt) {
            self.style = style
        }
    }
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        let view = replacedByNibView()
        if view != self {
            if let cell = view as? UITableViewCell {
                cell.copySubviewProperties(from: self)
            }
            (view as? NibReplaceable)?.removePlaceholders()
        }
        return view
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonAwake()
    }
    
    private var isAwake = false
    
    private func commonAwake() {
        if let destinationLabel = overridingTextLabel,
            let sourceLabel = super.textLabel
        {
            destinationLabel.copyNonDefaultProperties(from: sourceLabel)
            sourceLabel.attributedText = nil
        }
        if let destinationLabel = overridingDetailTextLabel,
            let sourceLabel = inheritedDetailTextLabel
        {
            destinationLabel.copyNonDefaultProperties(from: sourceLabel)
            sourceLabel.attributedText = nil
        }
        if let destination = overridingImageView,
            let source = super.imageView
        {
            destination.copyNonDefaultProperties(from: source)
            source.image = nil
        }
        isAwake = true
    }
    
    // MARK: - UIView
    
    open override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
        ) -> CGSize
    {
        var size = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: verticalFittingPriority
        )
        if size.height < minimumHeight {
            size.height = minimumHeight
        }
        return size
    }
    
}

extension NibTableViewCell: NibReplaceable {
    
    open var placeholderViews: [UIView] {
        return [textLabel, detailTextLabel, tertiaryTextLabel, actionView].compactMap { $0 }
    }
    
}

// Morphable

extension NibTableViewCell {
    
    public override func copyProperties(from view: UIView) {
        guard let cell = view as? UITableViewCell
            else { return }
        super.copyProperties(from: view)
        accessoryType = cell.accessoryType
    }
    
}
