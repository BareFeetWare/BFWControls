//
//  DismissAndPresentSegue.swift
//
//  Created by Tom Brodhurst-Hill on 15/06/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

class DismissAndPresentSegue: UIStoryboardSegue {

    override func perform() {
        if let presentingViewController = sourceViewController.presentingViewController {
            presentingViewController.dismissViewControllerAnimated(true, completion: {
                if let presentingNavigationController = presentingViewController as? UINavigationController ?? presentingViewController.navigationController {
                    presentingNavigationController.presentViewController(self.destinationViewController, animated: true, completion: nil)
                }
            })
        }
    }
    
}
