//
//  ReplaceInNavigationSegue.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 25/7/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public protocol NavigationReplacer {
    var replacedViewController: UIViewController? { get set }
}

open class ReplaceInNavigationSegue: UIStoryboardSegue {

    open override func perform() {
        source.replaceInNavigation(with: destination)
    }
    
}

public extension UIViewController {
    
    func replaceInNavigation(with replacerViewController: UIViewController) {
        guard var viewControllers = navigationController?.viewControllers
            else { return }
        viewControllers[viewControllers.count - 1] = replacerViewController.readiedForPush
        navigationController?.viewControllers = viewControllers
        if var replacer = replacerViewController as? NavigationReplacer {
            replacer.replacedViewController = self
        }
    }
    
}
