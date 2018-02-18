//
//  NibTableViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/3/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibTableViewCell: UITableViewCell {
    
    /// Should position to leading edge of the cellView to match the cell's separatorInset.left. Default = true.
    @IBInspectable open var isAlignedToInset: Bool = true { didSet { setNeedsAlignToInset() }}
    
    // MARK: - Init
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit(style: style)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        let styleInt = coder.decodeInteger(forKey: "UITableViewCellStyle")
        if let style = UITableViewCellStyle(rawValue: styleInt) {
            commonInit(style: style)
        }
    }
    
    /// Can be called from subclasses for taks common for init(coder:) and init(style:). Should call super.
    open func commonInit(style: UITableViewCellStyle) {
        let subview = contentSubview(for: style)
        contentView.addSubview(subview)
        subview.pinToSuperviewMargins()
        removeDetailTextLabelIfNotUsed(style: style)
    }
    
    private func removeDetailTextLabelIfNotUsed(style: UITableViewCellStyle) {
        guard let textLabel = cellView?.textLabel,
            let detailTextLabel = cellView?.detailTextLabel,
            style == .default
            else { return }
        textLabel.addConstraint(toBypass: detailTextLabel)
    }
    
    open func contentSubview(for style: UITableViewCellStyle) -> UIView {
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
        super.layoutSubviews()
    }
    
}
