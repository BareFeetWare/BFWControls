//
//  AutoNextViewController.swift
//
//  Created by Tom Brodhurst-Hill on 5/04/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class AutoNextViewController: UIViewController {

    // MARK: - Variables
    
    @IBInspectable open var segueIdentifier: String = "next"
    @IBInspectable open var delay: Double = 0.5
    @IBInspectable open var duration: Double = 1.0
    
    // MARK: - UIViewController

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let dispatchTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
        }
    }

}

