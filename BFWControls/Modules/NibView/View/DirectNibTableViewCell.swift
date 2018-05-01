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
    
    // MARK: - Init and awake
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        let labels = contentView.subviews.compactMap{ $0 as? UILabel }
        let replacedTextLabel = labels.first
        let replacedDetailTextLabel = labels.count >= 1
            ? labels[1]
            : nil
        let replacedImageView = contentView.subviews.compactMap { $0 as? UIImageView }.first
        guard let cell = viewFromNib as? UITableViewCell
            else { return self}
        if let textLabel = cell.textLabel,
            let replacedTextLabel = replacedTextLabel,
            let attributes = textLabel.attributedText?.attributes(at: 0, effectiveRange: nil)
        {
            textLabel.attributedText = replacedTextLabel.attributedText?.keepingTraitsAndColorButAdding(attributes: attributes)
        }
        if let detailTextLabel = cell.detailTextLabel,
            let replacedDetailTextLabel = replacedDetailTextLabel,
            let attributes = detailTextLabel.attributedText?.attributes(at: 0, effectiveRange: nil)
        {
            detailTextLabel.attributedText = replacedDetailTextLabel.attributedText?.keepingTraitsAndColorButAdding(attributes: attributes)
        }
        cell.imageView?.image = replacedImageView?.image
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
