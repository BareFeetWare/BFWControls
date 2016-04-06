//
//  TranslationAnimationController.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 4/04/2016.
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

class TranslationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Variables
    
    @IBInspectable var isPresenting: Bool = true
    @IBInspectable var duration: NSTimeInterval = 0.3
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var belowTopGuide: Bool = false
    @IBInspectable var animatePresenter = false // TODO: Determine automatically
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
    
    private func dismissedFrameInContainerView(containerView: UIView, direction: Direction) -> CGRect {
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
        let animateToView = animatePresenter || isPresenting
        let animateFromView = animatePresenter || !isPresenting
        let toViewController = animateToView ? transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) : nil
        let fromViewController = animateFromView ? transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) : nil
        if toViewController != nil {
            containerView.addSubview(toViewController!.view)
            let toDirection = animatePresenter && !isPresenting ? direction.reverse : direction
            toViewController?.view.frame = dismissedFrameInContainerView(containerView, direction: toDirection)
        }
        let fromDirection = animatePresenter && isPresenting ? direction.reverse : direction
        UIView.animateWithDuration(
            duration,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                fromViewController?.view.frame = self.dismissedFrameInContainerView(containerView, direction: fromDirection)
                toViewController?.view.frame = self.presentedFrameInContainerView(containerView)
            }
            )
        { finished in
            fromViewController?.view.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
}
