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
    
    // MARK: - IBOutlets
    
    @IBOutlet open var overridingTextLabel: UILabel?
    @IBOutlet open var overridingDetailTextLabel: UILabel?
    @IBOutlet open var overridingImageView: UIImageView?

    // MARK: - Init and awake
    
    private static var isLoadingFromNib = false
    
    private func loadedOnceFromNib() -> UIView {
        let view: UIView
        if type(of: self).isLoadingFromNib {
            view = self
        } else {
            type(of: self).isLoadingFromNib = true
            view = viewFromNib ?? self
            type(of: self).isLoadingFromNib = false
        }
        return view
    }
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        return loadedOnceFromNib()
    }

    // MARK: - UITableViewCell
    
    open override var textLabel: UILabel? {
        get {
            return overridingTextLabel
        }
        set {
            overridingTextLabel = newValue
        }
    }

    open override var detailTextLabel: UILabel? {
        get {
            return overridingDetailTextLabel
        }
        set {
            overridingDetailTextLabel = newValue
        }
    }

    open override var imageView: UIImageView? {
        get {
            return overridingImageView
        }
        set {
            overridingImageView = newValue
        }
    }
    
}
