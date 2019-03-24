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
    
    private var subviewFrames: [CGRect] {
        var subviewFrames: [CGRect] = []
        var startPoint = CGPoint.zero
        var maxRowHeight = CGFloat(0.0)
        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.noIntrinsicMetric)
            var leftGap = startPoint.x == 0.0 ? 0.0 : gapWidth
            let availableWidth = bounds.size.width - startPoint.x
            if availableWidth < subviewSize.width + leftGap {
                // Move to start of next row
                startPoint.y += maxRowHeight + gapHeight
                startPoint.x = 0.0
                maxRowHeight = 0.0
                leftGap = 0.0
            }
            maxRowHeight = max(maxRowHeight, subviewSize.height)
            let subviewFrame = CGRect(origin: CGPoint(x: startPoint.x + leftGap, y: startPoint.y),
                                      size: subviewSize)
            subviewFrames.append(subviewFrame)
            startPoint.x += leftGap + subviewSize.width
        }
        return subviewFrames
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
        zip(subviews, subviewFrames).forEach { $0.frame = $1 }
        heightConstraint?.constant = subviewFrames.last?.maxY ?? 0.0
        super.layoutSubviews()
    }
    
}

fileprivate extension CGSize {
    
    static let noIntrinsicMetric = CGSize(width: UIView.noIntrinsicMetric,
                                          height: UIView.noIntrinsicMetric)
    
}
