//
//  AutoNextViewController.swift
//
//  Created by Tom Brodhurst-Hill on 5/04/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

class AutoNextViewController: UIViewController {

    // MARK: - Variables
    
    @IBInspectable var segueIdentifier: String = "next"
    @IBInspectable var delay: Double = 0.5
    @IBInspectable var duration: Double = 1.0
    
    // MARK: - UIViewController

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.performSegueWithIdentifier(self.segueIdentifier, sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let morphSegue = segue as? MorphSegue {
            morphSegue.duration = duration
        }
    }

}

