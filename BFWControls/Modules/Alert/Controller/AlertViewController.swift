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
    @IBInspectable var action4Segue: String?
    @IBInspectable var action6Segue: String?
    @IBInspectable var action7Segue: String?
    @IBInspectable var autoDismisses: Bool = true
    
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
    
    private var segueIdentifiers: [String?] {
        return [action0Segue, action1Segue, action2Segue, action3Segue, action4Segue, action6Segue, action7Segue]
    }
    
    private let translationTransitioningController = TranslationTransitioningController()
    
    private var overlayView: UIView? {
        let overlayView = view.subviews.filter { subview in
            var white: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            subview.backgroundColor?.getWhite(&white, alpha: &alpha)
            return alpha < 1.0
            }.first
        return overlayView
    }
    
    private var onCompletion: (() -> Void)?
    
    // MARK: - Actions
    
    @IBAction func actionButton(button: UIButton) {
        let index = alertView.indexOfButton(button)!
        if alertView.hasCancel && index == 0 {
            dismissAlert(button)
        } else {
            onCompletion = { [weak self] _ in
                guard let strongSelf = self else { return }
                if let delegate = strongSelf.delegate {
                    delegate.alertView(strongSelf.alertView, clickedButtonAtIndex: index)
                } else {
                    let identifer = strongSelf.segueIdentifiers[index]
                        ?? strongSelf.alertView.buttonTitleAtIndex(index)!
                    strongSelf.performSegueWithIdentifier(identifer, sender: strongSelf.alertView)
                }
            }
            if !isInNavigationController && autoDismisses {
                dismissAlert(button)
            } else {
                onCompletion?()
            }
        }
    }
    
    @IBAction func dismissAlert(sender: AnyObject?) {
        if presentingViewController != nil {
            dismissViewControllerAnimated(true, completion: onCompletion)
        } else {
            onCompletion?()
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    private func hideOverlay() {
        view.backgroundColor = .clearColor()
        overlayView?.backgroundColor = .clearColor()
    }
    
    // MARK: - Init
    
    override init(nibName: String?, bundle: NSBundle?) {
        super.init(nibName: nibName, bundle: bundle)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        translationTransitioningController.backdropColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
        translationTransitioningController.direction = .Up
        transitioningDelegate = translationTransitioningController
        modalPresentationStyle = .OverFullScreen
    }
    
    // MARK: - UIViewController
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hideOverlay()
        // TODO: Fix responder chain for button taps when presenter still has text field as first responder. The following is a workaround.
        presentingViewController?.view.endEditing(true)
    }
    
}
