//
//  UIFont+Chain.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 1/5/19.
//  Copyright © 2019 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension UIFont {
    
    // MARK: - Convenience Init
    
    convenience init(familyName: String, size: CGFloat) {
        self.init(descriptor: UIFontDescriptor(fontAttributes: [.family : familyName]), size: size)
    }
    
    // MARK: - Instance Variables and Functions
    
    var bold: UIFont {
        return addingSymbolicTraits(.traitBold)
    }
    
    func resized(by multiplier: CGFloat) -> UIFont {
        return withSize(pointSize * multiplier)
    }
    
}
