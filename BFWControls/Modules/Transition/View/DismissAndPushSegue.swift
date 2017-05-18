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
        if let presentingViewController = source.presentingViewController {
            presentingViewController.dismiss(animated: true, completion: {
                if let presentingNavigationController = presentingViewController as? UINavigationController ?? presentingViewController.navigationController {
                    var destinationViewController = self.destination
                    if let destinationNavigationController = destinationViewController as? UINavigationController {
                        destinationViewController = destinationNavigationController.viewControllers.first!
                    }
                    presentingNavigationController.pushViewController(destinationViewController, animated: true)
                }
            })
        }
    }
    
}
