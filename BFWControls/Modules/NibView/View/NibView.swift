//
//  NibView.swift
//
//  Created by Tom Brodhurst-Hill on 27/03/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

class NibView: BFWNibView {

    // MARK: - updateView mechanism
    
    /// Override in subclasses and call super. Update view and subview properties that are affected by properties of this class.
    func updateView() {
    }
    
    private var needsUpdateView = true
        
    func setNeedsUpdateView() {
        needsUpdateView = true
        setNeedsLayout()
    }
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if needsUpdateView {
            updateView()
        }
    }

}
