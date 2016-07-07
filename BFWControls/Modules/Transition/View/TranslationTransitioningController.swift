//
//  TranslationTransitioningController.swift
//
//  Created by Tom Brodhurst-Hill on 21/03/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

class TranslationTransitioningController: NSObject, UIViewControllerTransitioningDelegate {

    // MARK: - Variables

    @IBInspectable var duration: NSTimeInterval = 0.3
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var belowTopGuide: Bool = false
    @IBInspectable var backdropColor: UIColor?

    /// Fade out/in the first view controller, instead of moving.
    @IBInspectable var fadeFirst: Bool = false

    var direction: Direction = .Up // Direction to which it presents. Dismiss direction defaults to opposite.

    @IBInspectable var direction_: Int {
        get {
            return direction.rawValue
        }
        set {
            direction = Direction(rawValue: newValue) ?? .Up
        }
    }

    private let animationController = TranslationAnimationController()

    // MARK: - Private functions

    private func updateAnimationController() {
        animationController.duration = self.duration
        animationController.leftInset = self.leftInset
        animationController.rightInset = self.rightInset
        animationController.topInset = self.topInset
        animationController.bottomInset = self.bottomInset
        animationController.belowTopGuide = self.belowTopGuide
        animationController.direction = self.direction
        animationController.backdropColor = self.backdropColor
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
        animationController.fadeFirst = fadeFirst
        return animationController
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = self.animationController
        updateAnimationController()
        animationController.isPresenting = false
        animationController.fadeFirst = fadeFirst
        return animationController
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
