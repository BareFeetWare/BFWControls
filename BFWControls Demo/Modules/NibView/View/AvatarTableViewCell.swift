//
//  AvatarTableViewCell.swift
//  BFWControls Demo
//
//  Created by Tom Brodhurst-Hill on 26/4/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//

import UIKit
import BFWControls

@IBDesignable class AvatarTableViewCell: NibTableViewCell {

    @IBOutlet var tertiaryTextLabel: UILabel?
    
    @IBInspectable var tertiaryText: String? {
        get {
            return tertiaryTextLabel?.text
        }
        set {
            tertiaryTextLabel?.text = newValue
        }
    }

}
