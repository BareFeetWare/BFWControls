//
//  AdjustableTableView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 4/11/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable open class AdjustableTableView: UITableView, Adjustable {
    
    // MARK: - Variables
    
    @IBInspectable open var isStickyHeader: Bool = false
    @IBInspectable open var isStickyFooter: Bool = false
    
    @IBInspectable open var isHiddenTrailingCells: Bool {
        get {
            return tableFooterView != nil
        }
        set {
            if newValue {
                if tableFooterView == nil {
                    // Don't show empty trailing cells:
                    tableFooterView = UIView()
                }
            } else {
                if tableFooterView?.bounds.size.height == 0.0 {
                    tableFooterView = nil
                }
            }
        }
    }
    
    // MARK: - Functions
    
    private func stickHeaderAndFooterIfNeeded() {
        if isStickyHeader {
            stickHeader()
        }
        if isStickyFooter {
            stickFooter()
        }
    }
    
    // MARK - Init
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    open func commonInit() {
    }
    
    // MARK: - UIView
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        stickHeaderAndFooterIfNeeded()
    }
    
}
