//
//  SideMenuTransitioningController.swift
//
//  Created by Tom Brodhurst-Hill on 21/03/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

enum Direction: Int {
    case Left = 0
    case Right = 1
    case Up = 2
    case Down = 3
    
    var reverse: Direction {
        switch self {
        case .Left:
            return .Right
        case .Right:
            return .Left
        case .Up:
            return .Down
        case .Down:
            return .Up
        }
    }
    
}

class SideMenuTransitioningController: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK: - Variables
    
    @IBInspectable var duration: Double = 0.3
    @IBInspectable var rightInset: CGFloat = 64.0
    
    lazy var transitioningController: TranslationTransitioningController = {
        let transitioningController = TranslationTransitioningController()
        transitioningController.duration = self.duration
        transitioningController.rightInset = self.rightInset
        transitioningController.direction = .Right
        return transitioningController
    }()
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
                             sourceController source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning?
    {
        return transitioningController.animationControllerForPresentedController(presented,
                                                                                 presentingController: presenting,
                                                                                 sourceController: source)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return transitioningController.animationControllerForDismissedController(dismissed)
    }

}

class TranslationTransitioningController: NSObject, UIViewControllerTransitioningDelegate {
    
    @IBInspectable var duration: NSTimeInterval = 0.3
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var belowTopGuide: Bool = false
    
    @IBInspectable var direction_: Int {
        get {
            return direction.rawValue
        }
        set {
            direction = Direction(rawValue: direction_) ?? .Left
        }
    }
    
    var direction: Direction = .Left // Direction to which it presents. Dismiss direction defaults to opposite.
    
    private func animationController() -> TranslationAnimationController {
        let animationController = TranslationAnimationController()
        animationController.duration = duration
        animationController.leftInset = leftInset
        animationController.rightInset = rightInset
        animationController.topInset = topInset
        animationController.bottomInset = bottomInset
        animationController.belowTopGuide = belowTopGuide
        animationController.direction = direction
        return animationController
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
                             sourceController source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning?
    {
        let animationController = self.animationController()
        animationController.isDismissing = false
        return animationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = self.animationController()
        animationController.isDismissing = true
        return animationController
    }
    
}

class TranslationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    @IBInspectable var isDismissing: Bool = true
    @IBInspectable var duration: NSTimeInterval = 0.3
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var belowTopGuide: Bool = false
    var direction: Direction = .Left // Direction to which it presents. Dismiss direction defaults to opposite.

    private func presentedFrameInContainerView(containerView: UIView) -> CGRect {
        // TODO: Use AutoLayout
        var frame = containerView.bounds
        frame.origin.x += leftInset
        frame.origin.y += topInset + (belowTopGuide ? 64.0 : 0.0) // TODO: Get layout guide y
        frame.size.width -= leftInset + rightInset
        frame.size.height -= frame.origin.y + bottomInset
        return frame
    }
    
    private func dismissedFrameInContainerView(containerView: UIView) -> CGRect {
        var frame = presentedFrameInContainerView(containerView)
        switch direction {
        case .Left:
            frame.origin.x += containerView.frame.size.width
        case .Right:
            frame.origin.x -= containerView.frame.size.width
        case .Up:
            frame.origin.y += containerView.frame.size.height
        case .Down:
            frame.origin.y += containerView.frame.size.height
        }
        return frame
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if !isDismissing {
            if let containerView = transitionContext.containerView(),
                let presentedViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
                let presentedView = presentedViewController.view
            {
                containerView.addSubview(presentedView)
                let sideMenuWidth = containerView.frame.size.width - rightInset
                presentedView.frame = CGRect(
                    x: -sideMenuWidth,
                    y: 0.0,
                    width: sideMenuWidth,
                    height: containerView.frame.size.height
                )
                UIView.animateWithDuration(
                    duration,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: {
                        presentedView.frame.origin.x = 0.0
                    }
                    )
                { finished in
                    transitionContext.completeTransition(true)
                }
            }
        } else {
            if let presentedViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
                let presentedView = presentedViewController.view
            {
                UIView.animateWithDuration(
                    duration,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: {
                        presentedView.frame.origin.x = -presentedView.frame.size.width
                    }
                    )
                { finished in
                    transitionContext.completeTransition(true)
                    presentedView.removeFromSuperview()
                }
            }
        }
    }
    
}

extension UIViewController {
    
    @IBOutlet var transitioningDelegateOutlet: NSObject? {
        get {
            return transitioningDelegate as? NSObject
        }
        set {
            transitioningDelegate = newValue as? UIViewControllerTransitioningDelegate
        }
    }
    
}

