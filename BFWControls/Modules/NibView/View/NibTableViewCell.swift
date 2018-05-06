//
//  NibTableViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 24/4/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable open class NibTableViewCell: CustomTableViewCell {
    
    // MARK: - IBOutlets
    
    // TODO: Perhaps integrate actionView with accessoryView
    
    @IBOutlet open var actionView: UIView?
    
    // MARK: - Variables
    
    @IBInspectable open var isActionViewHidden: Bool {
        get {
            return actionView?.isHidden ?? true
        }
        set {
            actionView?.isHidden = newValue
        }
    }
    
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
    
    // TODO: Move to NibReplaceable:
    
    open func replacedByNibView() -> UIView {
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
    
    // MARK: - Show nib content inside IB instance
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        guard let cell = replacedByNibView() as? UITableViewCell
            else { return }
        cell.copySubviewProperties(from: self)
        contentView.isHidden = true
        let subview = cell.contentView
        addSubview(subview)
        subview.pinToSuperviewEdges()
    }
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        let view = replacedByNibView()
        if let cell = view as? UITableViewCell {
            cell.copySubviewProperties(from: self)
        }
        (view as? NibReplaceable)?.removePlaceholders()
        return view
    }
    
}

extension NibTableViewCell: NibReplaceable {
    
    open var placeholderViews: [UIView] {
        return [textLabel, detailTextLabel].compactMap { $0 }
    }
    
}
