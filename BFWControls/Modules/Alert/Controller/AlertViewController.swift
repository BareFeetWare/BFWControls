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
    
    lazy var alertView: AlertView = {
        let foundAlertView: AlertView
        let alertViewOverlay = self.view.subviews.filter { subview in
            subview is AlertViewOverlay
        }.first as? AlertViewOverlay
        if let alertViewOverlay = alertViewOverlay {
            foundAlertView = alertViewOverlay.alertView
        } else {
            foundAlertView = self.view.subviews.filter { subview in
                subview is AlertView
                }.first as! AlertView
        }
        return foundAlertView
    }()
    
    // MARK: - Private variables
    
    private var isInNavigationController: Bool {
        return presentingViewController?.presentedViewController is UINavigationController
    }

    // MARK: - IBActions
    
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
    
    // MARK: - Init
    
    override init(nibName: String?, bundle: NSBundle?) {
        super.init(nibName: nibName, bundle: bundle)
        modalPresentationStyle = .OverFullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .OverFullScreen
    }
    
}
