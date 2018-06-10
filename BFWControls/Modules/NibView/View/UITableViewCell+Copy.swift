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
        if let destinationLabel = textLabel,
            let sourceLabel = sourceCell.textLabel
        {
            destinationLabel.copyNonDefaultProperties(from: sourceLabel)
        }
        if let destinationLabel = detailTextLabel,
            let sourceLabel = sourceCell.detailTextLabel
        {
            destinationLabel.copyNonDefaultProperties(from: sourceLabel)
        }
        if let sourceImageView = sourceCell.imageView {
            imageView?.image = sourceImageView.image
        }
    }
    
}
