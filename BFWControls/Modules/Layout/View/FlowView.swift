//
//  FlowView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 23/3/19.
//  Copyright © 2019 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

@IBDesignable open class FlowView: UIView {
    
    // MARK: - Variables
    
    @IBInspectable var gapWidth: CGFloat = 0.0
    @IBInspectable var gapHeight: CGFloat = 0.0
    
    private var heightConstraint: NSLayoutConstraint?
    
    // MARK: - Functions
    
    func addHeightConstraint() {
        heightConstraint = NSLayoutConstraint(item: self,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .height,
                                              multiplier: 1.0,
                                              constant: 100.0)
        addConstraint(heightConstraint!)
    }
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        addHeightConstraint()
    }
    
    // MARK: - UIView
    
    open override var intrinsicContentSize: CGSize {
        return subviews.reduce(CGSize.zero) { (size, subview) in
            let subviewSize = subview.sizeThatFits(.noIntrinsicMetric)
            let leftGap = size.width == 0.0 ? 0.0 : gapWidth
            return CGSize(width: size.width + leftGap + subviewSize.width,
                          height: max(size.height, subviewSize.height))
        }
    }
    
    open override func layoutSubviews() {
        var startPoint = CGPoint.zero
        var maxRowHeight = CGFloat(0.0)
        for subview in subviews {
            subview.layoutIfNeeded()
            var leftGap = startPoint.x == 0.0 ? 0.0 : gapWidth
            let availableWidth = frame.size.width - startPoint.x
            if availableWidth < subview.bounds.size.width + leftGap {
                // Move to start of next row
                startPoint.y += maxRowHeight + gapHeight
                startPoint.x = 0.0
                maxRowHeight = 0.0
                leftGap = 0.0
            }
            subview.frame.origin.x = startPoint.x + leftGap
            subview.frame.origin.y = startPoint.y
            startPoint.x += leftGap + subview.bounds.size.width
            maxRowHeight = max(maxRowHeight, subview.bounds.size.height)
        }
        heightConstraint?.constant = subviews.last?.frame.maxY ?? 0.0
        super.layoutSubviews()
    }
    
}

fileprivate extension CGSize {
    
    static let noIntrinsicMetric = CGSize(width: UIView.noIntrinsicMetric,
                                          height: UIView.noIntrinsicMetric)
    
}
