//
//  FixedWidthImageView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 14/12/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

/// Adjusts the intrinsicContentSize to always equal the width of the UIImageView bounds, and adjusts the height to keep aspect ratio. Also, if this view is in a table view, it tells that table view to adjust the cell heights, so the full image is visible.
open class FullWidthImageView: UIImageView {
    
    open override var intrinsicContentSize: CGSize {
        guard let image = image
            else { return .zero }
        let aspectRatio = image.size.width / image.size.height
        return CGSize(width: frame.size.width,
                      height: frame.size.width / aspectRatio)
    }
    
    open override func layoutSubviews() {
        invalidateIntrinsicContentSize()
        super.layoutSubviews()
        updateTableViewCellHeights()
    }
    
}
