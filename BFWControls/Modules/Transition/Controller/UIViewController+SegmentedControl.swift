//
//  UIViewController+SegmentedControl.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 25/7/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension UIViewController {
    
    @IBAction func switchTabBarItem(segmentedControl: UISegmentedControl) {
        guard let tabBarController = (self as? UITabBarController)
            ?? children.first as? UITabBarController
            ?? self.tabBarController
            else { return }
        let oldSelectedIndex = tabBarController.selectedIndex
        tabBarController.selectedIndex = segmentedControl.selectedSegmentIndex
        if tabBarController == self.tabBarController {
            segmentedControl.selectedSegmentIndex = oldSelectedIndex
        }
    }
    
}
