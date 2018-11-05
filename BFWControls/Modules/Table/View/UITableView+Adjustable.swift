//
//  UITableView+Adjustable.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 4/11/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

/*
// Implement in a subclass of UITableView:

override func layoutSubviews() {
    super.layoutSubviews()
    stickHeader()
    stickFooter()
}

// Or set up toggle variables, such as in AdjustableTableView and also below:

@IBInspectable open var isStickyHeader: Bool = false
@IBInspectable open var isStickyFooter: Bool = false

override func layoutSubviews() {
    super.layoutSubviews()
    stickHeaderAndFooterIfNeeded()
}

public func stickHeaderAndFooterIfNeeded() {
    if isStickyHeader {
        stickHeader()
    }
    if isStickyFooter {
        stickFooter()
    }
}
*/

import UIKit

public protocol Adjustable where Self: UITableView {
}

public extension Adjustable {
    
    private var bestContentInset: UIEdgeInsets {
        let insets: UIEdgeInsets
        if #available(iOS 11.0, *) {
            insets = adjustedContentInset
        } else {
            insets = contentInset
        }
        return insets
    }
    
    public func stickHeader() {
        if let stickyView = tableHeaderView {
            stickyView.frame.origin.y = max(0, contentOffset.y + bestContentInset.top)
            // Keep on top, so cells scroll underneath it:
            addSubview(stickyView)
        }
    }
    
    public func stickFooter() {
        if let stickyView = tableFooterView {
            stickyView.frame.origin.y = bounds.size.height + contentOffset.y - stickyView.bounds.size.height - bestContentInset.bottom
            // Keep on top, so cells scroll underneath it:
            addSubview(stickyView)
        }
    }
    
}
