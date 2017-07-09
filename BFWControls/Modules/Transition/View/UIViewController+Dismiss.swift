//
//  UIViewController+Dismiss.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 12/5/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension UIViewController {
    
    @IBAction public func dismiss(_ sender: UIControl?) {
        dismiss(animated: true) {}
    }
    
    public func removeDismiss() {
        // TODO: Cater for multiple leftBarButtonItems.
        if let selector = navigationItem.leftBarButtonItem?.action,
            selector == #selector(UIViewController.dismiss(_:))
        {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    var readiedForPush: UIViewController {
        if self is UINavigationController {
            debugPrint("**** error: pushing a navigation controller onlto a navigation controller. Stripping out second navigation controller, but this should be fixed.")
        }
        let strippedViewController = (self as? UINavigationController)?.viewControllers.first ?? self
        strippedViewController.removeDismiss()
        return strippedViewController
    }
    
}
