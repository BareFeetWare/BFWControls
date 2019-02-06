//
//  UIButton+Copy.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 20/11/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension UIButton {
    
    @objc func copySubviewProperties(from sourceButton: UIButton) {
        // TODO: Cycle through all state combinations?
        for state: UIControl.State in [.normal, .highlighted, .selected] {
            if let title = sourceButton.attributedTitle(for: state) {
                // TODO: Integrate copyNonDefaultProperties
                setAttributedTitle(title, for: state)
            } else if let title = sourceButton.title(for: state) {
                setTitle(title, for: state)
            }
            if let color = sourceButton.titleColor(for: state) {
                setTitleColor(color, for: state)
            }
            if let shadowColor = sourceButton.titleShadowColor(for: state) {
                setTitleShadowColor(shadowColor, for: state)
            }
            if let image = sourceButton.image(for: state) {
                setImage(image, for: state)
            }
        }
    }
    
}
