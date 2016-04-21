//
//  NibView.swift
//
//  Created by Tom Brodhurst-Hill on 27/03/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

class NibView: BFWNibView {

    // MARK: - UpdateView mechanism
    
    /// Override in subclasses and call super. Update view and subview properties that are affected by properties of this class.
    func updateView() {
    }
    
    func setNeedsUpdateView() {
        needsUpdateView = true
        setNeedsLayout()
    }
    
    // MARK: - Private variables and functions.
    
    private var needsUpdateView = true
        
    private func updateViewIfNeeded() {
        if needsUpdateView {
            needsUpdateView = false
            updateView()
        }
    }
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateViewIfNeeded()
    }

}
