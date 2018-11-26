//
//  TileButton.swift
//  BFWControls Demo
//
//  Created by Tom Brodhurst-Hill on 20/11/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//

import UIKit
import BFWControls

class TileButton: NibButton {

    open override var isHighlighted: Bool {
        didSet {
            // Testing selected state:
            if isHighlighted != oldValue && !isHighlighted {
                isSelected = !isSelected
            }
        }
    }

}
