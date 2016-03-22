//
//  SideMenuTransitioningController.swift
//
//  Created by Tom Brodhurst-Hill on 21/03/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

class SideMenuTransitioningController: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning?
    {
        return SideMenuAnimationController()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SideMenuDismissAnimationController()
    }
    
}

class SideMenuAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    let peekWidth: CGFloat = 44.0

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if let containerView = transitionContext.containerView(),
            let presentedViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let presentedView = presentedViewController.view
        {
            containerView.addSubview(presentedView)
            let sideMenuWidth = containerView.frame.size.width - peekWidth
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
    }
    
}

class SideMenuDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
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
