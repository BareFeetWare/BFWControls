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
        let view = replacedByNibView()
        if view != self {
            if let cell = view as? UITableViewCell {
                cell.copySubviewProperties(from: self)
            }
            (view as? NibReplaceable)?.removePlaceholders()
        }
        return view
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
    
    /// Override to give different nib for each cell style
    @IBInspectable open var nibName: String?
    
    open var style: UITableViewCell.CellStyle = .default
    
    // MARK: - Functions
    
    // TODO: Move to NibReplaceable:
    
    @objc open func replacedByNibView() -> UIView {
        return replacedByNibView(fromNibNamed: nibName ?? type(of: self).nibName)
    }
    
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
    
    private var isLoadingFromNib: Bool {
        return type(of: self).isLoadingFromNib
    }
    
    // Subviews in which UITableViewCell moves and sets properties. prepareForInterfaceBuilder() later copies those properties into our subviews and dump these subviews. This strategey prevents UITableViewCell from moving the subviews out of our nested layout.
    private let dumpTextLabel = UILabel()
    private let dumpDetailTextLabel = UILabel()
    private let dumpImageView = UIImageView()
    
    @IBOutlet open override var textLabel: UILabel? {
        get {
            return isFinishedPrepare
                ? overridingTextLabel ?? super.textLabel
                : dumpTextLabel
        }
        set {
            if isLoadingFromNib {
                overridingTextLabel = newValue
            }
        }
    }
    
    @IBOutlet open override var detailTextLabel: UILabel? {
        get {
            return isFinishedPrepare
                ? overridingDetailTextLabel ?? super.detailTextLabel
                : dumpDetailTextLabel
        }
        set {
            if isLoadingFromNib {
                overridingDetailTextLabel = newValue
            }
        }
    }
    
    @IBOutlet open override var imageView: UIImageView? {
        get {
            return isFinishedPrepare
                ? overridingImageView ?? super.imageView
                : dumpImageView
        }
        set {
            if isLoadingFromNib {
                overridingImageView = newValue
            }
        }
    }
    
    // #endif // TARGET_INTERFACE_BUILDER
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        overridingTextLabel?.copyNonDefaultProperties(from: dumpTextLabel)
        overridingDetailTextLabel?.copyNonDefaultProperties(from: dumpDetailTextLabel)
        overridingImageView?.copyNonDefaultProperties(from: dumpImageView)
        super.textLabel?.removeFromSuperview()
        dumpTextLabel.removeFromSuperview()
        dumpDetailTextLabel.removeFromSuperview()
        dumpImageView.removeFromSuperview()
        removePlaceholders()
        isFinishedPrepare = true
    }
    
    open override func layoutSubviews() {
        IBLog.write("layoutSubviews() {", indent: 1)
        super.layoutSubviews()
        offsetSubviewFramesIfNeeded()
        IBLog.write("}", indent: -1)
    }
    
    /// Implement workaround for bug in IB frames of textLabel, detailTextLabel, imageView.
    private var isOffsetSubviewFramesNeeded = true
    
    // Hack to figure out in which layoutSubviews() call after prepareForInterfaceBuilder, to adjust the frames so the selection in IB lines up.
    private var offsetCount = 0
    private let changeFrameOffsetCount = 3
    
    /// Workaround for bug in IB that does not show the correct frame for textLabel etc.
    private func offsetSubviewFramesIfNeeded() {
        guard isInterfaceBuilder && isOffsetSubviewFramesNeeded && isFinishedPrepare
            else { return }
        IBLog.write("offsetSubviewFramesIfNeeded() {", indent: 1)
        offsetCount += 1
        IBLog.write("offsetCount = \(offsetCount)")
        [textLabel, detailTextLabel, imageView].compactMap { $0 }.forEach { subview in
            let converted = subview.convert(CGPoint.zero, to: self)
            if offsetCount == changeFrameOffsetCount
                && converted.x > 0
                && converted.y > 0
            {
                IBLog.write("subview: \(subview.shortDescription) {", indent: 1)
                IBLog.write("old origin: \(subview.frame.origin)")
                subview.frame.origin = converted
                IBLog.write("new origin: \(subview.frame.origin)")
                IBLog.write("}", indent: -1)
            }
        }
        IBLog.write("}", indent: -1)
    }
    
    #endif // TARGET_INTERFACE_BUILDER
    
}

extension NibTableViewCell: NibReplaceable {
    
    open var placeholderViews: [UIView] {
        return [textLabel, detailTextLabel, tertiaryTextLabel, actionView].compactMap { $0 }
    }
    
}
