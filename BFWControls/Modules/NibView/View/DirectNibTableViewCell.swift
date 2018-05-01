//
//  DirectNibTableViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 24/4/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use and modify, without warranty.
//

import UIKit

@IBDesignable open class DirectNibTableViewCell: UITableViewCell {

    // MARK: - Overriding storage
    
    private var overridingTextLabel: UILabel?
    private var overridingDetailTextLabel: UILabel?
    private var overridingImageView: UIImageView?
    
    // MARK: - Init and awake
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        guard let cell = viewFromNib as? UITableViewCell
            else { return }
        cell.copySubviewProperties(from: self)
        contentView.isHidden = true
        let subview = cell.contentView
        addSubview(subview)
        subview.pinToSuperviewEdges()
    }
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        let view = viewFromNib
        if let cell = view as? UITableViewCell {
            cell.copySubviewProperties(from: self)
        }
        return view
    }
    
    // MARK: - UITableViewCell
    
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
    
}
