//
//  UITableViewCell+Copy.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 1/5/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use and modify, without warranty.
//

import UIKit

extension UITableViewCell {
    
    func copySubviewProperties(from sourceCell: UITableViewCell) {
        let labels = sourceCell.contentView.subviews.compactMap{ $0 as? UILabel }
        if let textLabel = textLabel,
            let replacedTextLabel = labels.first,
            let attributes = textLabel.attributedText?.attributes(at: 0, effectiveRange: nil)
        {
            textLabel.attributedText = replacedTextLabel.attributedText?.keepingTraitsAndColorButAdding(attributes: attributes)
        }
        if let detailTextLabel = detailTextLabel,
            labels.count >= 1,
            let attributes = detailTextLabel.attributedText?.attributes(at: 0, effectiveRange: nil)
        {
            let replacedDetailTextLabel = labels[1]
            detailTextLabel.attributedText = replacedDetailTextLabel.attributedText?.keepingTraitsAndColorButAdding(attributes: attributes)
        }
        if let replacedImageView = sourceCell.contentView.subviews.compactMap({ $0 as? UIImageView }).first {
            imageView?.image = replacedImageView.image
        }
    }
    
}
