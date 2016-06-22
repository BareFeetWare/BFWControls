//
//  AlertViewController.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 2/12/2015.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

protocol AlertViewDelegate {
    
    func alertView(alertView: AlertView, clickedButtonAtIndex index: Int)
    
}

class AlertViewController: UIViewController {
    
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

    // MARK: - Actions
    
    @IBAction func actionButton(button: UIButton) {
        let index = alertView.indexOfButton(button)!
        if alertView.hasCancel && index == 0 {
            dismissAlertView()
        } else {
            if let delegate = delegate {
                delegate.alertView(alertView, clickedButtonAtIndex: index)
            } else {
                let identifer = [action0Segue, action1Segue, action2Segue, action3Segue][index]
                    ?? alertView.buttonTitleAtIndex(index)!
                performSegueWithIdentifier(identifer, sender: alertView)
            }
            if !isInNavigationController {
                dismissAlertView()
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
