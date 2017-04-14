//
//  PileView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 25/11/16.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

@IBDesignable open class PileView: UIView {
    
    // MARK: - Variables
    
    @IBInspectable open var gapWidth: CGFloat = 0.0 { didSet { setNeedsLayout() }}
    @IBInspectable open var gapHeight: CGFloat = 0.0 { didSet { setNeedsLayout() }}
    
    fileprivate var subviewCount: CGFloat {
        return CGFloat(subviews.count)
    }
    
    fileprivate var subviewMaxWidth: CGFloat {
        return (bounds.size.width - (subviewCount - 1) * gapWidth) / subviewCount
    }
    
    // TODO: Dynamic
    open var subviewHeight: CGFloat = 44.0
    
    open var isHorizontal: Bool {
        let isHorizontal = subviews.reduce(true) { (doesFit, subview) in
            return doesFit && subview.sizeThatFits(bounds.size).width <= subviewMaxWidth
        }
        return isHorizontal
    }
    
    fileprivate var subviewWidth: CGFloat {
        return isHorizontal ? subviewMaxWidth : bounds.width
    }
    
    // MARK: - UIView
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric,
                      height: isHorizontal
                        ? subviewHeight
                        : subviewCount * subviewHeight + (subviewCount - 1) * gapHeight)
    }
    
    open override func layoutSubviews() {
        invalidateIntrinsicContentSize()
        for (index, subview) in subviews.enumerated() {
            let origin = isHorizontal
                ? CGPoint(x: (subviewWidth + gapWidth) * CGFloat(index),
                          y: 0.0)
                : CGPoint(x: 0.0,
                          y: (subviewHeight + gapHeight) * CGFloat(index))
            subview.frame = CGRect(origin: origin,
                                   size: CGSize(width: subviewWidth,
                                                height: subviewHeight))
        }
    }
    
}
