//
//  DismissAndPushSegue.swift
//
//  Created by Tom Brodhurst-Hill on 7/04/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

class DismissAndPushSegue: UIStoryboardSegue {

    override func perform() {
        if let presentingViewController = sourceViewController.presentingViewController {
            presentingViewController.dismissViewControllerAnimated(true, completion: {
                if let presentingNavigationController = presentingViewController as? UINavigationController ?? presentingViewController.navigationController {
                    var destinationViewController = self.destinationViewController
                    if let destinationNavigationController = destinationViewController as? UINavigationController {
                        destinationViewController = destinationNavigationController.viewControllers.first!
                    }
                    presentingNavigationController.pushViewController(destinationViewController, animated: true)
                }
            })
        }
    }
    
}
