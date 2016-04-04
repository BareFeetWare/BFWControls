//
//  TranslationAnimationController.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 4/04/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

class TranslationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Variables
    
    @IBInspectable var isPresenting: Bool = true
    @IBInspectable var duration: NSTimeInterval = 0.3
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var belowTopGuide: Bool = false
    var direction: Direction = .Left // Direction to which it presents. Dismiss direction defaults to reverse.
    
    // MARK: - Private functions
    
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
            frame.origin.y -= containerView.frame.size.height
        }
        return frame
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let presentedViewController = isPresenting ? toViewController : fromViewController
        if let presentedView = presentedViewController.view
        {
            let dismissedFrame = dismissedFrameInContainerView(containerView)
            var endFrame: CGRect
            if isPresenting {
                containerView.addSubview(presentedView)
                presentedView.frame = dismissedFrame
                endFrame = presentedFrameInContainerView(containerView)
            } else {
                endFrame = dismissedFrame
            }
            UIView.animateWithDuration(
                duration,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    presentedView.frame = endFrame
                }
                )
            { finished in
                transitionContext.completeTransition(true)
                if !self.isPresenting {
                    presentedView.removeFromSuperview()
                }
            }
        }
    }
    
}
