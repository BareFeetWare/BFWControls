//
//  TranslationAnimationController.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 4/04/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public enum Direction: Int {
    
    case left = 0
    case right = 1
    case up = 2
    case down = 3
    
    var reverse: Direction {
        switch self {
        case .left:
            return .right
        case .right:
            return .left
        case .up:
            return .down
        case .down:
            return .up
        }
    }
    
}

open class TranslationAnimationController: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    // MARK: - Variables
    
    @IBInspectable open var isPresenting: Bool = true
    @IBInspectable open var transitionDuration: CGFloat = 0.3
    @IBInspectable open var leftInset: CGFloat = 0.0
    @IBInspectable open var rightInset: CGFloat = 0.0
    @IBInspectable open var topInset: CGFloat = 0.0
    @IBInspectable open var bottomInset: CGFloat = 0.0
    @IBInspectable open var belowTopGuide: Bool = false
    @IBInspectable open var animatePresenter = false // TODO: Determine automatically
    /// Fade out/in the first view controller, instead of moving.
    @IBInspectable open var fadeFirst: Bool = false
    @IBInspectable open var backdropColor: UIColor?
    @IBInspectable open var blurBackground: Bool = false
    /// Direction to which it presents. Dismiss direction defaults to reverse.
    open var direction: Direction = .left
    let backdropView = UIView()
    let blurView = BlurView()
    open var isInteractive = false
    
    // MARK: - Private functions
    
    fileprivate func presentedFrame(in containerView: UIView) -> CGRect {
        // TODO: Use AutoLayout?
        var frame = containerView.bounds
        frame.origin.x += leftInset
        frame.origin.y += topInset + (belowTopGuide ? 64.0 : 0.0) // TODO: Get layout guide y
        frame.size.width -= leftInset + rightInset
        frame.size.height -= frame.origin.y + bottomInset
        return frame
    }
    
    fileprivate func dismissedFrame(in containerView: UIView, direction: Direction) -> CGRect {
        var frame = presentedFrame(in: containerView)
        switch direction {
        case .left:
            frame.origin.x += containerView.frame.size.width
        case .right:
            frame.origin.x -= containerView.frame.size.width
        case .up:
            frame.origin.y += containerView.frame.size.height
        case .down:
            frame.origin.y -= containerView.frame.size.height
        }
        return frame
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }
    
    @objc public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let animateToView = animatePresenter || fadeFirst || isPresenting
        let animateFromView = animatePresenter || fadeFirst || !isPresenting
        let toViewController = animateToView ? transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) : nil
        let fromViewController = animateFromView ? transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) : nil
        let presentingViewController = isPresenting ? fromViewController : toViewController
        let presentingNavigationController = presentingViewController as? UINavigationController ?? presentingViewController?.navigationController
        let isPush: Bool
        if let fromNavigationController = fromViewController?.navigationController,
            let toNavigationController = toViewController?.navigationController,
            fromNavigationController == toNavigationController
        {
            isPush = true
        } else {
            isPush = false
        }
        let isFirst = !isPush || (presentingNavigationController?.viewControllers.count == (isPresenting ? 2 : 1))
        let fadeFrom = fadeFirst && isPresenting && isFirst
        let fadeTo = fadeFirst && !isPresenting && isFirst
        if let toViewController = toViewController {
            if fromViewController == nil {
                containerView.addSubview(toViewController.view)
            } else if isPresenting {
                containerView.insertSubview(toViewController.view, aboveSubview: fromViewController!.view)
            } else {
                containerView.insertSubview(toViewController.view, belowSubview: fromViewController!.view)
                // Force layout of subviews in final positions (eg view controllers inset inside a navigation controller):
                toViewController.viewDidAppear(false)
            }
            if fadeTo {
                toViewController.view.frame = containerView.bounds
                toViewController.view.alpha = 0.0
            } else {
                let toDirection = animatePresenter && !isPresenting ? direction.reverse : direction
                toViewController.view.frame = dismissedFrame(in: containerView, direction: toDirection)
            }
            if let backdropColor = backdropColor {
                if !containerView.subviews.contains(backdropView) {
                    containerView.insertSubview(backdropView, belowSubview: toViewController.view)
                    backdropView.pinToSuperviewEdges()
                    backdropView.backgroundColor = backdropColor
                    backdropView.alpha = 0.0
                }
            }
            if blurBackground {
                blurView.frame = containerView.bounds
                containerView.insertSubview(blurView, belowSubview: toViewController.view)
                blurView.pinToSuperviewEdges()
                blurView.setNeedsDisplay()
                blurView.alpha = 0.5
            }
        }
        let fromDirection = animatePresenter && isPresenting ? direction.reverse : direction
        UIView.animate(
            withDuration: TimeInterval(transitionDuration),
            delay: 0.0,
            options: [.curveEaseInOut],
            animations: {
                if fadeFrom {
                    fromViewController?.view.alpha = 0.0
                } else {
                    fromViewController?.view.frame = self.dismissedFrame(in: containerView, direction: fromDirection)
                }
                if fadeTo {
                    toViewController?.view.alpha = 1.0
                } else {
                    toViewController?.view.frame = self.presentedFrame(in: containerView)
                }
                if self.isPresenting {
                    self.backdropView.alpha = 1.0
                    self.blurView.alpha = 1.0
                } else {
                    self.backdropView.alpha = 0.0
                    self.blurView.alpha = 0.0
                }
        }
            )
        { finished in
            self.blurView.removeFromSuperview()
            if transitionContext.transitionWasCancelled {
                toViewController?.view.removeFromSuperview()
            } else {
                fromViewController?.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractive ? self : nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractive ? self : nil
    }
    
}
