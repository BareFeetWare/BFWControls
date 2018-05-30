//
//  UITableViewCell+Copy.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 1/5/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use and modify, without warranty.
//

import UIKit

public extension UITableViewCell {
    
    @objc public func copySubviewProperties(from sourceCell: UITableViewCell) {
        if let textLabel = textLabel,
            let sourceTextLabel = sourceCell.textLabel,
            let attributes = textLabel.attributedText?.attributes(at: 0, effectiveRange: nil)
        {
            textLabel.attributedText = sourceTextLabel.attributedText?.keepingTraitsAndColorButAdding(attributes: attributes)
        }
        if let detailTextLabel = detailTextLabel,
            let sourceDetailTextLabel = sourceCell.detailTextLabel,
            let attributes = detailTextLabel.attributedText?.attributes(at: 0, effectiveRange: nil)
        {
            detailTextLabel.attributedText = sourceDetailTextLabel.attributedText?.keepingTraitsAndColorButAdding(attributes: attributes)
        }
        if let sourceImageView = sourceCell.imageView {
            imageView?.image = sourceImageView.image
        }
    }
    
}
