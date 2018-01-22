//
//  NibTableViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/3/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibTableViewCell: UITableViewCell {
    
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
    
    // MARK: - UIView
    
    open override func layoutSubviews() {
        if let leadingConstraint =
            constraints
            .first( where: { $0.firstAttribute == .leading })
            // TODO: Check that constraint is not to margin.
        {
            leadingConstraint.constant = separatorInset.left
        }
        super.layoutSubviews()
    }
    
}
