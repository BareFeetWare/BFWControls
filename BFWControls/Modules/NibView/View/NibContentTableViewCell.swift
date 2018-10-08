//
//  NibContentTableViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/3/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibContentTableViewCell: UITableViewCell {
    
    // MARK: Variables
    
    /// Minimum intrisicContentSize.height to use if table view uses auto dimension.
    @IBInspectable open var intrinsicHeight: CGFloat {
        get {
            return cellView?.intrinsicContentSize.height ?? UITableView.automaticDimension
        }
        set {
            cellView?.intrinsicSize = CGSize(width: UITableView.automaticDimension, height: newValue)
        }
    }
    
    /// Should position to the leading edge of the cellView to match the cell's separatorInset.left. Default = true.
    @IBInspectable open var isAlignedToInset: Bool = true { didSet { setNeedsAlignToInset() }}
    
    /// Modify this in subclasses to pin content subview to superview margins or edges.
    open var isContentSubviewPinnedToMargins: Bool = true { didSet { pinContentSubviewToContentView() }}
    
    // MARK: - UITableViewCell+Separator
    
    private var storedIsSeparatorHidden: Bool = false
    open var contentSubview: UIView?
    
    /// Workaround for iOS 9 by storing isSeparatorHidden, since large separatorInset.right shows a line on the left of separatorInset.left.
    @IBInspectable open override var isSeparatorHidden: Bool {
        get {
            if #available(iOS 10, *) {
                return super.isSeparatorHidden
            } else {
                return storedIsSeparatorHidden
            }
        }
        set {
            if #available(iOS 10, *) {
                super.isSeparatorHidden = newValue
            } else {
                storedIsSeparatorHidden = newValue
            }
        }
    }
    
    // MARK: - Init
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit(style: style)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        let styleInt = coder.decodeInteger(forKey: "UITableViewCellStyle")
        if let style = UITableViewCell.CellStyle(rawValue: styleInt) {
            commonInit(style: style)
        }
    }
    
    /// Can be called from subclasses for tasks common for init(coder:) and init(style:). Should call super.
    open func commonInit(style: UITableViewCell.CellStyle) {
        contentSubview = contentSubview(for: style)
        contentView.addSubview(contentSubview!)
        pinContentSubviewToContentView()
        removeDetailTextLabelIfNotUsed(style: style)
    }
    
    private func pinContentSubviewToContentView() {
        guard let contentSubview = contentSubview
            else { return }
        if let constraints = contentView.constraints(with: contentSubview) {
            NSLayoutConstraint.deactivate(constraints)
        }
        if isContentSubviewPinnedToMargins {
            contentSubview.pinToSuperviewMargins()
        } else {
            contentSubview.pinToSuperviewEdges()
        }
    }
    
    private func removeDetailTextLabelIfNotUsed(style: UITableViewCell.CellStyle) {
        guard let textLabel = cellView?.textLabel,
            let detailTextLabel = cellView?.detailTextLabel,
            style == .default
            else { return }
        textLabel.addConstraint(toBypass: detailTextLabel)
    }
    
    open func contentSubview(for style: UITableViewCell.CellStyle) -> UIView {
        switch style {
        default:
            fatalError("Concrete subclass must provide contentSubview(for style:).")
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        commonAwake()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonAwake()
    }
    
    private var isAwake = false
    
    private func commonAwake() {
        guard let cellView = cellView
            else { return }
        cellView.textLabel?.attributedText = super.textLabel?.attributedText
        cellView.detailTextLabel?.attributedText = super.detailTextLabel?.attributedText
        super.textLabel?.attributedText = nil
        super.detailTextLabel?.attributedText = nil
        isAwake = true
    }
    
    // MARK: - UITableViewCell
    
    open override var textLabel: UILabel? {
        return isAwake
            ? cellView?.textLabel
            : super.textLabel
    }
    
    open override var detailTextLabel: UILabel? {
        return isAwake
            ? cellView?.detailTextLabel
            : super.detailTextLabel
    }
    
    open override var separatorInset: UIEdgeInsets { didSet { setNeedsAlignToInset() }}
    
    // MARK: - Update Inset
    
    private var needsAlignToInset = true
    
    private func setNeedsAlignToInset() {
        needsAlignToInset = true
        setNeedsLayout()
    }
    
    private func alignToInsetIfNeeded() {
        if needsAlignToInset {
            needsAlignToInset = false
            alignToInset()
        }
    }
    
    private func alignToInset() {
        guard let cellView = cellView,
            let leadingConstraint = contentView
                .constraints(with: cellView)?
                .first( where: { [.leading, .left, .leadingMargin, .leftMargin].contains($0.firstAttribute) })
            else { return }
        if isAlignedToInset {
            let insetPlusIndentationLeft = CGFloat(indentationLevel) * indentationWidth + separatorInset.left
            let difference = insetPlusIndentationLeft - layoutMargins.left
            leadingConstraint.constant = max(difference, 0.0)
        } else {
            leadingConstraint.constant = 0.0
        }
    }
    
    // MARK: - UIView
    
    open override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        setNeedsAlignToInset()
    }
    
    open override func layoutSubviews() {
        alignToInsetIfNeeded()
        if #available(iOS 10, *) {
            // Nothing extra to do.
        } else {
            updateIsSeparatorHidden()
        }
        super.layoutSubviews()
    }
    
}
