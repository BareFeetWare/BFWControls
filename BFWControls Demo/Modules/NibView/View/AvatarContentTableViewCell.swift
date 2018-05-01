//
//  AvatarContentTableViewCell.swift
//  BFWControls Demo
//
//  Created by Tom Brodhurst-Hill on 4/3/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit
import BFWControls

@IBDesignable class AvatarContentTableViewCell: NibContentTableViewCell {
    
    override func contentSubview(for style: UITableViewCellStyle) -> UIView {
        return AvatarCellView()
    }
    
}
