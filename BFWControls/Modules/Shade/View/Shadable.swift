//
//  Shadable.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 24/6/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//

import UIKit

public protocol Shadable {
    
    // Required:
    
    var lightShade: Bool { get set }
    var autoShade: Bool { get set }
    
    // Optional:
    
    var priority: Int { get set }
    var lightColors: [UIColor] { get set }
    var darkColors: [UIColor] { get }
    
    // Implemented by extension:
    
    var applicableLightShade: Bool { get }
    var shadeColor: UIColor { get }
    
}

public extension Shadable where Self: UIView {
    
    var priority: Int {
        return 0
    }
    
    var lightColors: [UIColor] {
        return [.white, .lightGray, .gray, .darkGray, .black]
    }
    
    var darkColors: [UIColor] {
        return lightColors.reversed()
    }
    
    var applicableLightShade: Bool {
        let isLightShade = autoShade
            ? (superview as? Shadable)?.applicableLightShade
                ?? isBackgroundLight
                ?? lightShade
            : lightShade
        return isLightShade
    }
    
    var shadeColor: UIColor {
        let colors = applicableLightShade
            ? lightColors
            : darkColors
        let index = max(priority, colors.count - 1)
        let color = colors[index]
        return color
    }

}
