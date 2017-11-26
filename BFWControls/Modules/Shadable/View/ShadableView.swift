//
//  ShadableView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 23/7/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

/// UIView for grouping subviews under a single Shadable setting.
open class ShadableView: UIView, Shadable {
    
    // MARK: - Shadable
    
    @IBInspectable open var isLight: Bool = false { didSet { setNeedsUpdateView() }}
    @IBInspectable open var isLightAuto: Bool = true { didSet { setNeedsUpdateView() }}
    
    // This is a background color, so should be dark when content isLight.
    public var lightColors: [UIColor] = [.white, .darkGray, .black].reversed()
    
    private func applyShade() {
        backgroundColor = shadeColor
    }
    
    // MARK: - Updatable
    
    private var needsUpdateView = true
    
    private func setNeedsUpdateView() {
        needsUpdateView = true
        setNeedsLayout()
    }
    
    func updateViewIfNeeded() {
        if needsUpdateView {
            needsUpdateView = false
            applyShade()
        }
    }
    
    // MARK: UIView
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateViewIfNeeded()
    }
    
}
