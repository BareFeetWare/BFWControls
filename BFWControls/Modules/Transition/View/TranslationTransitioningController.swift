//
//  TranslationTransitioningController.swift
//
//  Created by Tom Brodhurst-Hill on 21/03/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
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

