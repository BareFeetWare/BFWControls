//
//  BackgroundTableView.swift
//  BFWControls Demo
//
//  Created by Tom Brodhurst-Hill on 19/11/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//

import UIKit
import BFWControls

@IBDesignable class BackgroundTableView: AdjustableTableView {

    lazy var navigationBackgroundView: UIView = BackgroundView()
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        // Show the background in Interface Builder to simulate what we see at runtime from the navigation controller's view behind.
        backgroundView = navigationBackgroundView
    }
    
    override func commonInit() {
        super.commonInit()
        isHiddenTrailingCells = true
        backgroundColor = UIColor.clear
    }
    
}
