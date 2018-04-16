//
//  AlertViewController.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 2/12/2015.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public protocol AlertViewDelegate {
    
    func alertView(_ alertView: AlertView, clickedButtonAt index: Int)
    
}

open class AlertViewController: UIViewController {
    
    // MARK: - Variables
    
    @IBInspectable open var action0Segue: String?
    @IBInspectable open var action1Segue: String?
    @IBInspectable open var action2Segue: String?
    @IBInspectable open var action3Segue: String?
    @IBInspectable open var action4Segue: String?
    @IBInspectable open var action6Segue: String?
    @IBInspectable open var action7Segue: String?
    @IBInspectable open var autoDismisses: Bool = true
    
    open var delegate: AlertViewDelegate?
    
    lazy open var alertView: AlertView = {
        let foundAlertView: AlertView
        let alertViewOverlay = self.view.subviews.first { subview in
            subview is AlertViewOverlay
            } as? AlertViewOverlay
        if let alertViewOverlay = alertViewOverlay {
            foundAlertView = alertViewOverlay.alertView
        } else {
            foundAlertView = self.view.subviews.first { subview in
                subview is AlertView
                } as! AlertView
        }
        return foundAlertView
    }()
    
    // MARK: - Private variables
    
    fileprivate var isInNavigationController: Bool {
        return presentingViewController?.presentedViewController is UINavigationController
    }
    
    fileprivate var segueIdentifiers: [String?] {
        return [action0Segue, action1Segue, action2Segue, action3Segue, action4Segue, action6Segue, action7Segue]
    }
    
    fileprivate let translationTransitioningController = TranslationTransitioningController()
    
    fileprivate var overlayView: UIView? {
        let overlayView = view.subviews.first { subview in
            var white: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            subview.backgroundColor?.getWhite(&white, alpha: &alpha)
            return alpha < 1.0
        }
        return overlayView
    }
    
    fileprivate var onCompletion: (() -> Void)?
    
    // MARK: - Actions
    
    @IBAction open func actionButton(_ button: UIButton) {
        let index = alertView.index(of: button)!
        if alertView.hasCancel && index == 0 {
            dismissAlert(button)
        } else {
            onCompletion = { [weak self] in
                guard let strongSelf = self else { return }
                if let delegate = strongSelf.delegate {
                    delegate.alertView(strongSelf.alertView, clickedButtonAt: index)
                }
            }
            if delegate == nil,
                let identifier = segueIdentifiers[index]
                    ?? alertView.buttonTitle(at: index)
            {
                performSegue(withIdentifier: identifier, sender: alertView)
            }
            if !isInNavigationController && autoDismisses {
                dismissAlert(button)
            } else {
                onCompletion?()
            }
        }
    }
    
    @IBAction open func dismissAlert(_ sender: AnyObject?) {
        if presentingViewController != nil {
            dismiss(animated: true, completion: onCompletion)
        } else {
            CATransaction.begin()
            CATransaction.setCompletionBlock(onCompletion)
            navigationController?.popViewController(animated: true)
            CATransaction.commit()
        }
    }
    
    fileprivate func hideOverlay() {
        overlayView?.backgroundColor = .clear
    }
    
    // MARK: - Init
    
    public override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    open func commonInit() {
        translationTransitioningController.backdropColor = UIColor.black.withAlphaComponent(0.75)
        translationTransitioningController.direction = .up
        transitioningDelegate = translationTransitioningController
        modalPresentationStyle = .overFullScreen
    }
    
    // MARK: - UIViewController
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideOverlay()
        // TODO: Fix responder chain for button taps when presenter still has text field as first responder. The following is a workaround.
        presentingViewController?.view.endEditing(true)
    }
    
}
