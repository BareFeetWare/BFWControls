//
//  PileView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 25/11/16.
//  Updated by Santhosh Thiyagarajan on 13/6/17.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

/// An interface for laying out a collection of views in one row if possible else stacked in one column.
@IBDesignable open class PileView: UIView {
    
    /// The gap required in between the views when layed out horizontally.
    @IBInspectable open var gapWidth: CGFloat = 0.0 { didSet { setNeedsLayout() }}
    
    /// The gap required in between the views when layed out vertically.
    @IBInspectable open var gapHeight: CGFloat = 0.0 { didSet { setNeedsLayout() }}
    
    /// Number of subviews in the pile view.
    private var subviewCount: CGFloat {
        return CGFloat(subviews.count)
    }
    
    /// Maximum width the pile view can stretch to. This is worked out based on pileview's superview's width and its leading and trailing constraints with its superview.
    private var maxWidth: CGFloat {
        guard let superview = superview else { return bounds.size.width }
        guard let constraintsWithSuperview = constraints(with: superview) else { return superview.bounds.size.width }
        let centerXConstraintWithSuperview = constraintsWithSuperview.filter({ $0.firstAttribute == .centerX }).first
        let leadingConstraintWithSuperview = constraintsWithSuperview.filter({ $0.firstAttribute == .leading }).first?.constant ?? 0
        let trailingConstraintWithSuperview = constraintsWithSuperview.filter({ $0.firstAttribute == .trailing }).first?.constant ?? 0
        if centerXConstraintWithSuperview != nil {
            return (superview.bounds.size.width - (subviewCount - 1) * gapWidth - (trailingConstraintWithSuperview + leadingConstraintWithSuperview) * 2)
        } else {
            return (superview.bounds.size.width - (subviewCount - 1) * gapWidth - trailingConstraintWithSuperview - leadingConstraintWithSuperview)
        }
    }
    
    /// Total width of the subviews when they are layed out horizontally.
    private var subviewsTotalWidth: CGFloat {
        let totalWidth: CGFloat = subviews.reduce(0) { (totalWidth, subview) in
            return (totalWidth + subview.intrinsicContentSize.width)
        }
        return totalWidth + (subviewCount - 1) * gapWidth
    }
    
    /// Total height of the subviews when they are layed out vertically.
    private var subviewsTotalHeight: CGFloat {
        let totalHeight: CGFloat = subviews.reduce(0) { (totalHeight, subview) in
            return (totalHeight + subview.intrinsicContentSize.height)
        }
        return totalHeight + (subviewCount - 1) * gapHeight
    }
    
    /// Boolean which indicates whether the subviews can be layed out horizontally.
    private var isHorizontal: Bool {
        return maxWidth >= subviewsTotalWidth
    }
    
    /// Returns intrinsic content size by laying out subviews either horizontally or vertically.
    open override var intrinsicContentSize: CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        if isHorizontal {
            width  = subviews.reduce(0) { (result, subview) in
                return (result + subview.intrinsicContentSize.width)
            }
            width += (subviewCount - 1)*gapWidth
            height  = subviews.reduce(0) { (result, subview) in
                return max(result, subview.intrinsicContentSize.height)
            }
        } else  {
            width  = subviews.reduce(0) { (result, subview) in
                return max(result, subview.intrinsicContentSize.width)
            }
            height  = subviews.reduce(0) { (result, subview) in
                return (result + subview.intrinsicContentSize.height)
            }
            height += (subviewCount - 1)*gapHeight
        }
        return CGSize(width: width, height: height)
    }
    
    
    /// Returns origin for a subview
    ///
    /// - Parameters:
    ///   - subview: Current subview
    ///   - previousSubview: Previous subview
    /// - Returns: Origin as CGPoint
    private func getOrigin(for subview: UIView, previousSubview: UIView?) -> CGPoint {
        var subviewOriginY: CGFloat = 0.0
        var subviewOriginX: CGFloat = 0.0
        if isHorizontal {
            subviewOriginX = previousSubview != nil
                ? previousSubview!.frame.origin.x + previousSubview!.bounds.size.width + gapWidth
                : 0.0
        } else  {
            subviewOriginY = previousSubview != nil
                ? previousSubview!.frame.origin.y + previousSubview!.bounds.size.height + gapHeight
                : 0.0
        }
        return CGPoint(x: subviewOriginX, y: subviewOriginY)
    }
    
    /// Subviews layed out horizontally or vertically.
    open override func layoutSubviews() {
        invalidateIntrinsicContentSize()
        for (index, subview) in subviews.enumerated() {
            for eachContraint in subview.constraints {
                subview.removeConstraint(eachContraint)
            }
            let subviewWidth = min(subview.intrinsicContentSize.width, bounds.size.width)
            let subviewHeight = min(subview.intrinsicContentSize.height, bounds.size.height)
            let origin = getOrigin(for: subview, previousSubview: (index > 0 ? subviews[index-1] : nil))
            subview.frame = CGRect(origin: origin,
                                   size: CGSize(width: subviewWidth,
                                                height: subviewHeight))
        }
    }
    
}
