//
//  CustomTableViewCell.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 30/07/2015.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable class CustomTableViewCell: UITableViewCell {

    // MARK: - Public variables
    
    @IBOutlet override var textLabel: UILabel? {
        get {
            return overridingTextLabel
        }
        set {
            overridingTextLabel = newValue
        }
    }
    
    @IBOutlet override var detailTextLabel: UILabel? {
        get {
            return overridingDetailTextLabel
        }
        set {
            overridingDetailTextLabel = newValue
        }
    }

    @IBOutlet override var imageView: UIImageView? {
        get {
            return overridingImageView
        }
        set {
            overridingImageView = newValue
        }
    }

    // MARK: - Private variables
    
    fileprivate var overridingTextLabel: UILabel?
    fileprivate var overridingDetailTextLabel: UILabel?
    fileprivate var overridingImageView: UIImageView?

}
