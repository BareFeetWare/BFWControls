//
//  PileView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 25/11/16.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

@IBDesignable class PileView: UIView {
    
    // MARK: - Variables
    
    @IBInspectable var gapWidth: CGFloat = 0.0 { didSet { setNeedsLayout() }}
    @IBInspectable var gapHeight: CGFloat = 0.0 { didSet { setNeedsLayout() }}
    
    private var subviewCount: CGFloat {
        return CGFloat(subviews.count)
    }
    
    private var subviewMaxWidth: CGFloat {
        return (bounds.size.width - (subviewCount - 1) * gapWidth) / subviewCount
    }
    
    // TODO: Dynamic
    var subviewHeight: CGFloat = 44.0
    
    var isHorizontal: Bool {
        let isHorizontal = subviews.reduce(true) { (doesFit, subview) in
            return doesFit && subview.sizeThatFits(bounds.size).width <= subviewMaxWidth
        }
        return isHorizontal
    }
    
    private var subviewWidth: CGFloat {
        return isHorizontal ? subviewMaxWidth : bounds.width
    }
    
    // MARK: - UIView
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric,
                      height: isHorizontal
                        ? subviewHeight
                        : subviewCount * subviewHeight + (subviewCount - 1) * gapHeight)
    }
    
    override func layoutSubviews() {
        invalidateIntrinsicContentSize()
        for (index, subview) in subviews.enumerate() {
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
