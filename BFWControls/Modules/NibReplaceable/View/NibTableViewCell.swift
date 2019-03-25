//
//  NibTableViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 24/4/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable open class NibTableViewCell: BFWNibTableViewCell, NibReplaceable {
    
    // MARK: - NibReplaceable
    
    open var nibName: String?
    
    open var placeholderViews: [UIView] {
        return [textLabel, detailTextLabel, tertiaryTextLabel, actionView].compactMap { $0 }
    }
    
    // MARK: - IBOutlets
    
    #if !TARGET_INTERFACE_BUILDER
    
    @IBOutlet open override var textLabel: UILabel? {
        get {
            return overridingTextLabel ?? super.textLabel
        }
        set {
            overridingTextLabel = newValue
        }
    }
    
    @IBOutlet open override var detailTextLabel: UILabel? {
        get {
            return overridingDetailTextLabel ?? super.detailTextLabel
        }
        set {
            overridingDetailTextLabel = newValue
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
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        guard let nibView = replacedByNibView()
            else { return self }
        nibView.copySubviewProperties(from: self)
        nibView.removePlaceholders()
        return nibView
    }
    
    #endif // !TARGET_INTERFACE_BUILDER
    
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
    
    open var style: UITableViewCell.CellStyle = .default
    
    // MARK: - Init
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.style = style
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        let styleInt = coder.decodeInteger(forKey: "UITableViewCellStyle")
        if let style = UITableViewCell.CellStyle(rawValue: styleInt) {
            self.style = style
        }
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
    
    // MARK: - IBDesignable
    
    #if TARGET_INTERFACE_BUILDER
    let isInterfaceBuilder = true
    #else
    let isInterfaceBuilder = false
    #endif
    
    #if TARGET_INTERFACE_BUILDER
    
    private var isFinishedPrepare = false
    
    @IBOutlet open override var textLabel: UILabel? {
        get {
            return isFinishedPrepare
                ? overridingTextLabel
                : super.textLabel ?? UILabel()
        }
        set {
            if overridingTextLabel == nil {
                overridingTextLabel = newValue
            }
        }
    }
    
    @IBOutlet open override var detailTextLabel: UILabel? {
        get {
            return isFinishedPrepare
                ? overridingDetailTextLabel
                : superDetailTextLabel ?? UILabel()
        }
        set {
            if overridingDetailTextLabel == nil {
                overridingDetailTextLabel = newValue
            }
        }
    }
    
    @IBOutlet open override var imageView: UIImageView? {
        get {
            return isFinishedPrepare
                ? overridingImageView
                : super.imageView
        }
        set {
            if overridingImageView == nil {
                overridingImageView = newValue
            }
        }
    }
    
    /// super.detailTextLabel returns nil even though super.textLabel returns the label, so resorting to subviews:
    private var superDetailTextLabel: UILabel? {
        let label: UILabel?
        if let detailTextLabel = super.detailTextLabel {
            label = detailTextLabel
        } else {
            let superLabels = super.contentView.subviews.filter { $0 is UILabel } as! [UILabel]
            label = superLabels.count == 2
                ? superLabels[1]
                : nil
        }
        return label
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        if let destination = overridingTextLabel,
            let source = super.textLabel
        {
            if !["Text", "Title"].contains(source.text) {
                destination.copyNonDefaultProperties(from: source)
            }
            source.attributedText = nil
        }
        if let destination = overridingDetailTextLabel {
            if let source = superDetailTextLabel
            {
                if !["Detail", "Subtitle"].contains(source.text) {
                    destination.copyNonDefaultProperties(from: source)
                }
                source.attributedText = nil
            } else {
                destination.text = nil
            }
        }
        if let destination = overridingImageView,
            let source = super.imageView
        {
            destination.copyNonDefaultProperties(from: source)
            source.image = nil
        }
        isFinishedPrepare = true
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        offsetSubviewFramesIfNeeded()
    }
    
    /// Implement workaround for bug in IB frames of textLabel, detailTextLabel, imageView.
    private var isOffsetSubviewFramesNeeded = true
    private var isOffsetSubviewFramesFinished = false
    
    // Hack to figure out in which layoutSubviews() call after prepareForInterfaceBuilder, to adjust the frames so the selection in IB lines up.
    private var offsetCount = 0
    private let changeFrameOffsetCount = 2
    
    /// Workaround for bug in IB that does not show the correct frame for textLabel etc.
    private func offsetSubviewFramesIfNeeded() {
        guard isInterfaceBuilder && isOffsetSubviewFramesNeeded && isFinishedPrepare
            else { return }
        IBLog.write("offsetSubviewFramesIfNeeded() {", indent: 1)
        offsetCount += 1
        IBLog.write("offsetCount = \(offsetCount)")
        if offsetCount == changeFrameOffsetCount {
            [textLabel, detailTextLabel, imageView].compactMap { $0 }.forEach { subview in
                let converted = subview.convert(CGPoint.zero, to: self)
                if converted.x > 0
                    && converted.y > 0
                {
                    IBLog.write("subview: \(subview.shortDescription) {", indent: 1)
                    IBLog.write("old origin: \(subview.frame.origin)")
                    subview.frame.origin = converted
                    IBLog.write("new origin: \(subview.frame.origin)")
                    IBLog.write("}", indent: -1)
                }
            }
            isOffsetSubviewFramesFinished = true
        }
        IBLog.write("}", indent: -1)
    }
    
    #endif // TARGET_INTERFACE_BUILDER
    
}

@objc public extension NibTableViewCell {
    
    @objc func replacedByNibViewForInit() -> Self? {
        return replacedByNibView()
    }
    
}
