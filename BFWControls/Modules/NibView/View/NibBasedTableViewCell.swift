//
//  NibBasedTableViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 14/1/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class NibBasedTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    
    /// Set to true for instances that are not the source of truth. In the xib containing the subview layout, set this to false. In instances that should use that xib, such as in a storyboard, set to true.
    @IBInspectable open var shouldLoadFromNib: Bool = false
    
    // MARK: - IBOutlets
    
    /// Connect in Interface Builder in the base xib.
    @IBOutlet open var overridingTextLabel: UILabel? {
        didSet {
            overridingTextLabel?.text = textLabel?.text
        }
    }
    /// Connect in Interface Builder in the base xib.
    @IBOutlet open var overridingDetailTextLabel: UILabel?
    
    // MARK: - UITableViewCell
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let nibView = viewFromNib as! NibBasedTableViewCell
        self.copySubviews(nibView.subviews, includeConstraints: true)
//        self.copyProperties(from: nibView)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override var textLabel: UILabel? {
        return overridingTextLabel ?? super.textLabel
    }
    
    open override var detailTextLabel: UILabel? {
        return overridingDetailTextLabel ?? super.detailTextLabel
    }
    
    // MARK: - UIView
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        let view: UITableViewCell?
        if shouldLoadFromNib || tag == 1 {
            view = viewFromNib as? UITableViewCell
            view?.textLabel?.text = textLabel?.text
            view?.detailTextLabel?.text = detailTextLabel?.text
            // Testing
            view?.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        } else {
            view = self
        }
        return view
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        if tag == 1 {
            
        }
    }
    
}

extension NibBasedTableViewCell: NSKeyedUnarchiverDelegate {
    
    public func unarchiver(_ unarchiver: NSKeyedUnarchiver, willReplace object: Any, with newObject: Any) {
        debugPrint("willReplace: \(object), with: \(newObject)")
    }
}
