//
//  TranslationTransitioningController.swift
//
//  Created by Tom Brodhurst-Hill on 21/03/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

class TranslationTransitioningController: UIPercentDrivenInteractiveTransition {

    // MARK: - Variables

    private var storedDuration: CGFloat = 0.3
    @IBInspectable override var duration: CGFloat {
        get {
            return storedDuration
        }
        set {
            storedDuration = newValue
        }
    }
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var belowTopGuide: Bool = false
    @IBInspectable var backdropColor: UIColor?
    @IBInspectable var interactive: Bool = true

    /// Fade out/in the first view controller, instead of moving.
    @IBInspectable var fadeFirst: Bool = false

    /// Direction to which it presents. Dismiss direction defaults to opposite.
    var direction: Direction = .Up

    @IBInspectable var direction_: Int {
        get {
            return direction.rawValue
        }
        set {
            direction = Direction(rawValue: newValue) ?? .Up
        }
    }

    private let animationController = TranslationAnimationController()
    private let interactionController = UIPercentDrivenInteractiveTransition()

    // MARK: - Private functions

    private func updateAnimationController() {
        animationController.duration = NSTimeInterval(duration)
        animationController.leftInset = leftInset
        animationController.rightInset = rightInset
        animationController.topInset = topInset
        animationController.bottomInset = bottomInset
        animationController.belowTopGuide = belowTopGuide
        animationController.direction = direction
        animationController.fadeFirst = fadeFirst
        animationController.backdropColor = backdropColor
        if interactive {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(interactiveDismiss(_:)))
            animationController.backdropView.addGestureRecognizer(tapGestureRecognizer)
        }
    }

    // MARK: - UIViewControllerTransitioningDelegate

    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning?
    {
        let animationController = self.animationController
        updateAnimationController()
        animationController.isPresenting = true
        return animationController
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = self.animationController
        updateAnimationController()
        animationController.isPresenting = false
        return animationController
    }
    
}

// MARK: - UIViewControllerInteractiveTransitioning

extension TranslationTransitioningController {

    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactive {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(interactiveDismiss(_:)))
            animationController.backdropView.addGestureRecognizer(tapGestureRecognizer)
        }
        return interactionController
    }
    
    func interactiveDismiss(gestureRecognizer: UITapGestureRecognizer) {
        interactionController.finishInteractiveTransition()
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
