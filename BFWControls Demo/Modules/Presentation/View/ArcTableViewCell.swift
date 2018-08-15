//
//  ArcTableViewCell.swift
//  BFWControls Demo
//
//  Created by Tom Brodhurst-Hill on 9/8/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit
import BFWControls

@IBDesignable class ArcTableViewCell: NibTableViewCell {

    @IBOutlet weak var arcView: ArcView!
    
    @IBInspectable var arcEnd: Double {
        get {
            return arcView.end
        }
        set {
            arcView.end = newValue
        }
    }
    
}
