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
    
    @objc func copySubviewProperties(from sourceCell: UITableViewCell) {
        if let sourceLabel = sourceCell.textLabel {
            textLabel?.copyNonDefaultProperties(from: sourceLabel)
        }
        if let sourceLabel = sourceCell.detailTextLabel {
            detailTextLabel?.copyNonDefaultProperties(from: sourceLabel)
        }
        if let sourceImageView = sourceCell.imageView {
            imageView?.copyNonDefaultProperties(from: sourceImageView)
        }
    }
    
}
