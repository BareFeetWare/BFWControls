//
//  DismissAndPushSegue.swift
//
//  Created by Tom Brodhurst-Hill on 7/04/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class DismissAndPushSegue: UIStoryboardSegue {

    open override func perform() {
        if let tabBarController = source.presentingViewController as? UITabBarController,
            let topViewController = (tabBarController.selectedViewController as? UINavigationController)?.topViewController
        {
            dismissAndPush(from: topViewController)
        } else if let presentingViewController = source.presentingViewController {
            dismissAndPush(from: presentingViewController)
        }
    }
    
    private func dismissAndPush(from presentingViewController: UIViewController) {
        presentingViewController.dismiss(animated: true, completion: {
            if let presentingNavigationController = presentingViewController as? UINavigationController ?? presentingViewController.navigationController {
                presentingNavigationController.pushViewController(self.destination.firstViewController, animated: true)
            }
        })
    }
}
