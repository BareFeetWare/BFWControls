//
//  AutoNextViewController.swift
//
//  Created by Tom Brodhurst-Hill on 5/04/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

class AutoNextViewController: UIViewController {

    // MARK: - Variables
    
    @IBInspectable var segueIdentifier: String = "next"
    @IBInspectable var delay: Double = 0.5
    @IBInspectable var duration: Double = 1.0
    
    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let dispatchTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let morphSegue = segue as? MorphSegue {
            morphSegue.duration = duration
        }
    }

}

