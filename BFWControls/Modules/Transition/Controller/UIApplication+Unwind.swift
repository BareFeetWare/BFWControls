//
//  UIApplication+Unwind.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 18/6/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

extension UIApplication {
    
    public var backmostViewController: UIViewController {
        let window = keyWindow ?? windows.first!
        return window.rootViewController!.firstViewController
    }
    
    public var frontmostViewController: UIViewController {
        return backmostViewController.frontViewController
    }
    
    public func unwindToBackmostViewController(animated: Bool) {
        backmostViewController.unwindToSelf(animated: animated)
    }
    
}
