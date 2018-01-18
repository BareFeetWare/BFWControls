//
//  NibTableViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/3/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibTableViewCell: UITableViewCell {
    
    // MARK: - NibView container
    
    private func addContentSubview() {
        contentView.addSubview(nibView)
        nibView.pinToSuperviewEdges()
    }
    
    open var nibView: NibView {
        fatalError("Concrete subclass must provide nibView.")
    }
    
    // MARK: - Init
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    open func commonInit() {
        addContentSubview()
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
        guard let cellView = nibView as? TextLabelProvider
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
        if let leadingConstraint = textLabel?
            .constraints(with: textLabel!.superview!)?
            .first( where: { $0.firstAttribute == .leading })
            // TODO: Check that constraint is not to margin.
        {
            leadingConstraint.constant = separatorInset.left
        }
        super.layoutSubviews()
    }
    
}
