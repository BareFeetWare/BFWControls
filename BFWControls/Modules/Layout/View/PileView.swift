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
        return (bounds.width - (subviewCount - 1) * gapWidth) / subviewCount
    }
    
    private var contentHeight: CGFloat {
        let heights = subviews.map { $0.intrinsicContentSize().height }
        return isHorizontal
            ? heights.maxElement()!
            : heights.reduce (0) { $0 + $1 } + (subviewCount - 1) * gapHeight
    }
    
    var isHorizontal: Bool {
        let subviewMaxWidth = self.subviewMaxWidth
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
                      height: contentHeight)
    }
    
    override func layoutSubviews() {
        invalidateIntrinsicContentSize()
        let isHorizontal = self.isHorizontal
        var sumOfHeight: CGFloat = 0.0
        for (index, subview) in subviews.enumerate() {
            let origin: CGPoint
            let subviewHeight = subview.sizeThatFits(bounds.size).height
            if isHorizontal {
                origin = CGPoint(x: (subviewWidth + gapWidth) * CGFloat(index),
                                 y: 0.0)
            } else {
                origin = CGPoint(x: 0.0,
                                 y: sumOfHeight)
                sumOfHeight += subviewHeight + gapHeight
            }
            subview.frame = CGRect(origin: origin,
                                   size: CGSize(width: subviewWidth,
                                                height: subviewHeight))
        }
    }
    
}
