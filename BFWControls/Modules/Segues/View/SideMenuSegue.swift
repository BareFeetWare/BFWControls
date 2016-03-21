//
//  SideMenuSegue.swift
//
//  Created by Tom Brodhurst-Hill on 20/03/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

class SideMenuSegue: UIStoryboardSegue {

    override func perform() {
        destinationViewController.transitioningDelegate = TransitionManager.sharedTransitionManager
        destinationViewController.modalPresentationStyle = .Custom
        sourceViewController.navigationController?.presentViewController(self.destinationViewController, animated: true, completion: nil)
    }
    
}
