//
//  TranslationAnimationController.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 4/04/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

enum Direction: Int {

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

class TranslationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Variables

    @IBInspectable var isPresenting: Bool = true
    @IBInspectable var duration: TimeInterval = 0.3
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var belowTopGuide: Bool = false
    @IBInspectable var animatePresenter = false // TODO: Determine automatically
    /// Fade out/in the first view controller, instead of moving.
    @IBInspectable var fadeFirst: Bool = false
    @IBInspectable var backdropColor: UIColor?
    /// Direction to which it presents. Dismiss direction defaults to reverse.
    var direction: Direction = .left
    let backdropView = UIView()
    
    // MARK: - Private functions

    fileprivate func presentedFrameInContainerView(_ containerView: UIView) -> CGRect {
        // TODO: Use AutoLayout?
        var frame = containerView.bounds
        frame.origin.x += leftInset
        frame.origin.y += topInset + (belowTopGuide ? 64.0 : 0.0) // TODO: Get layout guide y
        frame.size.width -= leftInset + rightInset
        frame.size.height -= frame.origin.y + bottomInset
        return frame
    }

    fileprivate func dismissedFrameInContainerView(_ containerView: UIView, direction: Direction) -> CGRect {
        var frame = presentedFrameInContainerView(containerView)
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

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
                toViewController.view.frame = dismissedFrameInContainerView(containerView, direction: toDirection)
            }
            if let backdropColor = backdropColor {
                if !containerView.subviews.contains(backdropView) {
                    containerView.insertSubview(backdropView, belowSubview: toViewController.view)
                    backdropView.pinToSuperviewEdges()
                    backdropView.backgroundColor = backdropColor
                    backdropView.alpha = 0.0
                }
            }
        }
        let fromDirection = animatePresenter && isPresenting ? direction.reverse : direction
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: [.curveEaseInOut],
            animations: {
                if fadeFrom {
                    fromViewController?.view.alpha = 0.0
                } else {
                    fromViewController?.view.frame = self.dismissedFrameInContainerView(containerView, direction: fromDirection)
                }
                if fadeTo {
                    toViewController?.view.alpha = 1.0
                } else {
                    toViewController?.view.frame = self.presentedFrameInContainerView(containerView)
                }
                if self.isPresenting {
                    self.backdropView.alpha = 1.0
                } else {
                    self.backdropView.alpha = 0.0
                }
            }
            )
        { finished in
            if transitionContext.transitionWasCancelled {
                toViewController?.view.removeFromSuperview()
            } else {
                fromViewController?.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
}
