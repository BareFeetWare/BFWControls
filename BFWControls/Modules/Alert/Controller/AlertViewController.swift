//
//  AlertViewController.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 2/12/2015.
//  Copyright © 2015 BareFeetWare. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController, AlertViewDelegate {
    
    // MARK: - Variables

    @IBInspectable var action0Segue: String?
    @IBInspectable var action1Segue: String?
    @IBInspectable var action2Segue: String?
    @IBInspectable var action3Segue: String?
    
    var delegate: AlertViewDelegate?
    
    @IBOutlet lazy var alertView: AlertView! = {
        let alertViewOverlay = self.view.subviews.filter { subview in
            subview is AlertViewOverlay
        }.first as! AlertViewOverlay
        return alertViewOverlay.alertView
    }()

    // MARK: - Private variables
    
    private var isInNavigationController: Bool {
        return presentingViewController?.presentedViewController is UINavigationController
    }
    
    // MARK: - AlertViewDelegate
    
    func alertView(alertView: AlertView, clickedButtonAtIndex index: Int) {
        if alertView.hasCancel && index == 0 {
            dismissAlertView()
        } else {
            if !isInNavigationController {
                dismissAlertView()
            }
            if let delegate = delegate {
                delegate.alertView(alertView, clickedButtonAtIndex: index)
            } else {
                let identifer = [action0Segue, action1Segue, action2Segue, action3Segue][index]
                    ?? alertView.buttonTitleAtIndex(index)!
                performSegueWithIdentifier(identifer, sender: alertView)
            }
        }
    }

    // MARK: - Actions
    
    func dismissAlertView() {
        if presentingViewController != nil {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
}
