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

class SideMenuTransitioningController: AbstractTransitioningController {
    
    // MARK: - Variables
    
    @IBInspectable var duration: Double = 0.3
    @IBInspectable var rightInset: CGFloat = 44.0
    
    // MARK: - Init

    override init() {
        super.init()
        transitioningController.duration = duration
        transitioningController.rightInset = rightInset
        transitioningController.direction = .Right
    }
    
}

/// Subclass AbstractTransitioningController and customise properties of its transitioningDelegate.
class AbstractTransitioningController: NSObject, UIViewControllerTransitioningDelegate {

    // MARK: - Variables

    var transitioningController = TranslationTransitioningController()

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
    
    // MARK: - Variables

    @IBInspectable var duration: NSTimeInterval = 0.3
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var belowTopGuide: Bool = false
    var direction: Direction = .Left // Direction to which it presents. Dismiss direction defaults to opposite.
    
    @IBInspectable var direction_: Int {
        get {
            return direction.rawValue
        }
        set {
            direction = Direction(rawValue: newValue) ?? .Left
        }
    }
    
    // MARK: - Private functions
    
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
        animationController.isPresenting = true
        return animationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = self.animationController()
        animationController.isPresenting = false
        return animationController
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
    var direction: Direction = .Left // Direction to which it presents. Dismiss direction defaults to opposite.

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
        let key = isPresenting ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey
        if let presentedViewController = transitionContext.viewControllerForKey(key),
            let presentedView = presentedViewController.view,
            let containerView = isPresenting ? transitionContext.containerView() : presentedView.superview
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

