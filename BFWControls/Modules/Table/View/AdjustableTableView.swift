//
//  AdjustableTableView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 4/11/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable class AdjustableTableView: UITableView, Adjustable {
    
    // MARK: - Variables
    
    @IBInspectable open var isStickyHeader: Bool = false
    @IBInspectable open var isStickyFooter: Bool = false
    
    // MARK: - Functions
    
    private func stickHeaderAndFooterIfNeeded() {
        if isStickyHeader {
            stickHeader()
        }
        if isStickyFooter {
            stickFooter()
        }
    }
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stickHeaderAndFooterIfNeeded()
    }
    
}
