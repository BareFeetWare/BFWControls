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
    @IBInspectable open var isInsetAligned: Bool = true { didSet { updateInset() }}
    
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
    
    open func commonInit(style: UITableViewCellStyle) {
        let nibView = self.nibView(for: style)
        contentView.addSubview(nibView)
        nibView.pinToSuperviewEdges()
    }
    
    open func nibView(for style: UITableViewCellStyle) -> NibView {
        switch style {
        default:
            fatalError("Concrete subclass must provide nibView(for style:).")
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
        cellView.textLabel?.text = super.textLabel?.text
        cellView.detailTextLabel?.text = super.detailTextLabel?.text
        super.textLabel?.text = nil
        super.detailTextLabel?.text = nil
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
    
    open override var separatorInset: UIEdgeInsets {
        didSet {
            updateInset()
        }
    }
    
    // MARK: - UIView
    
    private func updateInset() {
        guard let cellView = cellView,
            let constraints = contentView.constraints(with: cellView)
            else { return }
        constraints
            .first( where: { [.leading, .left].contains($0.firstAttribute) })?
            .constant = CGFloat(indentationLevel) * indentationWidth
            + (isInsetAligned ? separatorInset.left : 0.0)
    }
    
    open override func layoutSubviews() {
        updateInset()
        super.layoutSubviews()
    }
    
}
