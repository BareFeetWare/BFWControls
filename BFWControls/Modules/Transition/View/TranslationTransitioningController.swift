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

    @IBInspectable var duration: TimeInterval = 0.3
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var belowTopGuide: Bool = false
    @IBInspectable var backdropColor: UIColor?

    /// Fade out/in the first view controller, instead of moving.
    @IBInspectable var fadeFirst: Bool = false

    /// Direction to which it presents. Dismiss direction defaults to opposite.
    var direction: Direction = .up

    @IBInspectable var direction_: Int {
        get {
            return direction.rawValue
        }
        set {
            direction = Direction(rawValue: newValue) ?? .up
        }
    }

    fileprivate let animationController = TranslationAnimationController()

    // MARK: - Private functions

    fileprivate func updateAnimationController() {
		animationController.animateDuration = duration
        animationController.leftInset = leftInset
        animationController.rightInset = rightInset
        animationController.topInset = topInset
        animationController.bottomInset = bottomInset
        animationController.belowTopGuide = belowTopGuide
        animationController.direction = direction
        animationController.backdropColor = backdropColor
    }

    // MARK: - UIViewControllerTransitioningDelegate

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning?
    {
        let animationController = self.animationController
        updateAnimationController()
        animationController.isPresenting = true
        animationController.fadeFirst = fadeFirst
        return animationController
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
