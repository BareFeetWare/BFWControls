//
//  DirectNibTableViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 24/4/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use and modify, without warranty.
//

import UIKit

open class DirectNibTableViewCell: BFWNibTableViewCell {
    
    // MARK: - Overriding storage
    
    private var overridingTextLabel: UILabel?
    private var overridingDetailTextLabel: UILabel?
    private var overridingImageView: UIImageView?
    private var replacedTextLabel: UILabel?
    private var replacedDetailTextLabel: UILabel?
    private var replacedImageView: UIImageView?
    
    // MARK: - Init and awake
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        let labels = contentView.subviews.compactMap{ $0 as? UILabel }
        replacedTextLabel = labels.first
        if labels.count >= 1 {
            replacedDetailTextLabel = labels[1]
        }
        replacedImageView = contentView.subviews.compactMap { $0 as? UIImageView }.first
    }
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        let cell = viewFromNib as? UITableViewCell
        cell?.textLabel?.text = replacedTextLabel?.text
        cell?.detailTextLabel?.text = replacedDetailTextLabel?.text
        cell?.imageView?.image = replacedImageView?.image
        replacedTextLabel = nil
        replacedDetailTextLabel = nil
        replacedImageView = nil
        return cell
    }
    
    // MARK: - UITableViewCell
    
    @IBOutlet open override var textLabel: UILabel? {
        get {
            return overridingTextLabel
        }
        set {
            overridingTextLabel = newValue
        }
    }
    
    @IBOutlet open override var detailTextLabel: UILabel? {
        get {
            return overridingDetailTextLabel
        }
        set {
            overridingDetailTextLabel = newValue
        }
    }
    
    @IBOutlet open override var imageView: UIImageView? {
        get {
            return overridingImageView
        }
        set {
            overridingImageView = newValue
        }
    }
    
}
