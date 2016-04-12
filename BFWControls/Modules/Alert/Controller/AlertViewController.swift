//
//  AlertViewController.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 2/12/2015.
//  Copyright © 2015 BareFeetWare. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController, AlertViewDelegate {
    
    // MARK: - AlertViewDelegate
    
    func action0Button(button: UIButton) {
        actionButton(button, segueIdentifier: "action0")
    }
    
    func action1Button(button: UIButton) {
        actionButton(button, segueIdentifier: "action1")
    }
    
    func action2Button(button: UIButton) {
        actionButton(button, segueIdentifier: "action2")
    }
    
    func action3Button(button: UIButton) {
        actionButton(button, segueIdentifier: "action3")
    }
    
    // MARK: - Actions
    
    func actionButton(button: UIButton, segueIdentifier: String) {
        if canPerformSegueWithIdentifier(segueIdentifier) {
            performSegueWithIdentifier(segueIdentifier, sender: button)
        } else {
            actionCancelButton(button)
        }
    }
    
    func actionCancelButton(sender: UIButton) {
        if presentingViewController != nil {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
}

extension UIViewController {
    
    func canPerformSegueWithIdentifier(identifier: NSString) -> Bool {
        var can = false
        if let templates = self.valueForKey("storyboardSegueTemplates") as? NSArray {
            let predicate = NSPredicate(format: "identifier=%@", identifier)
            let filteredtemplates = templates.filteredArrayUsingPredicate(predicate)
            can = !filteredtemplates.isEmpty
        }
        return can
    }
    
}