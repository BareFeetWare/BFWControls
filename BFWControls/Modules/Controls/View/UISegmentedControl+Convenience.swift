//
//  UISegmentedControl+Convenience.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 16/12/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension UISegmentedControl {
    
    var selectedTitle: String {
        get {
            return titleForSegment(at: selectedSegmentIndex)!
        }
        set {
            guard let index = (0 ..< numberOfSegments).first(where: { titleForSegment(at: $0) == newValue } )
                else { return }
            selectedSegmentIndex = index
        }
    }
    
}
