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
    
    // MARK: - IBDesignable
    
    #if TARGET_INTERFACE_BUILDER
    
    private var nibTextLabel: UILabel?
    private var nibDetailTextLabel: UILabel?
    private var nibImageView: UIImageView?
    
    private var isLoadingFromNib: Bool {
        return type(of: self).isLoadingFromNib
    }
    
    @IBOutlet open override var textLabel: UILabel? {
        get {
            IBLog.write("textLabel get", indent: 1)
            let label = overridingTextLabel ?? super.textLabel
            IBLog.write("textLabel get, return \(label.shortDescription)", indent: -1)
            return label
        }
        set {
            IBLog.write("textLabel set", indent: 1)
            IBLog.write("newValue: \(newValue.shortDescription)")
            IBLog.write("isLoadingFromNib = \(isLoadingFromNib)")
            if !isLoadingFromNib {
                IBLog.write("overridingTextLabel = nibTextLabel")
                overridingTextLabel = nibTextLabel
                super.textLabel?.text = nil
            } else {
                IBLog.write("nibTextLabel = newValue")
                nibTextLabel = newValue
            }
            IBLog.write("textLabel set, done", indent: -1)
        }
    }
    
    @IBOutlet open override var detailTextLabel: UILabel? {
        get {
            IBLog.write("detailTextLabel get", indent: 1)
            let label = overridingDetailTextLabel ?? super.detailTextLabel
            IBLog.write("detailTextLabel get, return \(label.shortDescription)", indent: -1)
            return label
        }
        set {
            IBLog.write("detailTextLabel set", indent: 1)
            IBLog.write("newValue: \(newValue.shortDescription)")
            IBLog.write("isLoadingFromNib = \(isLoadingFromNib)")
            if !isLoadingFromNib {
                IBLog.write("overridingDetailTextLabel = nibDetailTextLabel")
                overridingDetailTextLabel?.text = nil
                overridingDetailTextLabel = nibDetailTextLabel
            } else {
                IBLog.write("nibDetailTextLabel = newValue")
                nibDetailTextLabel = newValue
                // detailTextLabel must be not nil or else IBDesignable will stop with an error.
                let nonNilLabel = UILabel()
                nonNilLabel.backgroundColor = UIColor.red
                nonNilLabel.text = "non nil"
                overridingDetailTextLabel = nonNilLabel
            }
            IBLog.write("detailTextLabel set, done", indent: -1)
        }
    }
    
    @IBOutlet open override var imageView: UIImageView? {
        get {
            IBLog.write("imageView get", indent: 1)
            let imageView = overridingImageView ?? super.imageView
            IBLog.write("imageView get, return \(imageView.shortDescription)", indent: -1)
            return imageView
        }
        set {
            IBLog.write("imageView set", indent: 1)
            IBLog.write("newValue: \(newValue.shortDescription)")
            IBLog.write("isLoadingFromNib = \(isLoadingFromNib)")
            if !isLoadingFromNib {
                IBLog.write("overridingImageView = nibImageView")
                overridingImageView = nibImageView
                overridingImageView?.image = super.imageView?.image
                super.imageView?.image = nil
            } else {
                IBLog.write("nibImageView = newValue")
                nibImageView = newValue
            }
            IBLog.write("imageView set, done", indent: -1)
        }
    }
    
    open override func prepareForInterfaceBuilder() {
        IBLog.write("prepareForInterfaceBuilder()", indent: 1)
        IBLog.write("super.prepareForInterfaceBuilder()")
        super.prepareForInterfaceBuilder()
        IBLog.write("overridingTextLabel: \(overridingTextLabel.shortDescription)")
        IBLog.write("super.textLabel: \(super.textLabel.shortDescription)")
        IBLog.write(contentView.recursiveDescription())
        IBLog.write("prepareForInterfaceBuilder() end", indent: -1)
    }
    
    open override func awakeFromNib() {
        IBLog.write("awakefromNib()", indent: 1)
        IBLog.write("super.awakefromNib()")
        super.awakeFromNib()
        IBLog.write("awakefromNib() done", indent: -1)
    }
    
    // MARK: - UIView
    
    open override func layoutSubviews() {
        IBLog.write("layoutSubviews()", indent: 1)
        IBLog.write(recursiveDescription())
        IBLog.write("super.layoutSubviews()")
        super.layoutSubviews()
        IBLog.write(shortDescription)
        IBLog.write("layoutSubviews() done", indent: -1)
    }

    #else
    
    // MARK: - IBOutlets
    
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
    
    #endif
    
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
        IBLog.write("replacedByNibView()", indent: 1)
        let view = replacedByNibView(fromNibNamed: nibName ?? type(of: self).nibName)
        IBLog.write("replacedByNibView(), return \(view.shortDescription)", indent: -1)
        return view
    }
    
    // MARK: - Init
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        IBLog.write("init(style)", indent: 1)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.style = style
        IBLog.write("init(style) done, self = \(shortDescription)", indent: -1)
    }
    
    public required init?(coder: NSCoder) {
        IBLog.write("init(coder)", indent: 1)
        super.init(coder: coder)
        let styleInt = coder.decodeInteger(forKey: "UITableViewCellStyle")
        if let style = UITableViewCell.CellStyle(rawValue: styleInt) {
            self.style = style
        }
        IBLog.write("init(coder) done, self = \(shortDescription)", indent: -1)
    }
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        IBLog.write("awakeAfter(using)", indent: 1)
        let view = replacedByNibView()
        if view != self {
            if let cell = view as? UITableViewCell {
                cell.copySubviewProperties(from: self)
            }
            (view as? NibReplaceable)?.removePlaceholders()
        }
        IBLog.write("awakeAfter(using) return \(view.shortDescription)", indent: -1)
        return view
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
