//
//  NibContainerSegmentedControl.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 17/7/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use and modify, without warranty.
//

import UIKit

open class NibContainerSegmentedControl: UISegmentedControl {
    
    // MARK: - NibView container
    
    open var nibView: NibView {
        fatalError("Concrete subclass must provide nibView.")
    }
    
    // MARK: - UpdateView
    
    var needsUpdateView = true
    
    func setNeedsUpdateView() {
        needsUpdateView = true
    }
    
    func updateViewIfNeeded() {
        if needsUpdateView {
            needsUpdateView = false
            updateView()
        }
    }
    
    func updateView() {
        setDividerImage(UIImage(),
                        forLeftSegmentState: .normal,
                        rightSegmentState: .normal,
                        barMetrics: .default)
        let cellView = nibView as! NibCellView
        setTitleTextAttributes(cellView.textLabel?.attributedText?.attributes(at: 0, effectiveRange: nil), for: .normal)
        cellView.textLabel?.text = nil
        for state: UIControl.State in [.normal, .selected] {
            cellView.accessoryView?.isHidden = state == .normal
            let segmentWidth: CGFloat = 10.0 // arbitrary since stretched
            cellView.frame.size.width = segmentWidth
            let image = cellView.image(
                size: CGSize(width: segmentWidth,
                             height: bounds.height)
            )
            setBackgroundImage(image, for: state, barMetrics: .default)
        }
    }
    
    // MARK: - UIView
    
    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = nibView.intrinsicContentSize.height
        return size
    }
    
    open override func layoutSubviews() {
        updateViewIfNeeded()
        super.layoutSubviews()
    }
}
