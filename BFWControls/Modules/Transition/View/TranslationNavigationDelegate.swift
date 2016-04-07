//
//  TranslationNavigationDelegate.swift
//
//  Created by Tom Brodhurst-Hill on 7/04/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

class TranslationNavigationDelegate: NSObject, UINavigationControllerDelegate {

    // MARK: - Variables

    @IBInspectable var duration: NSTimeInterval = 0.3
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var belowTopGuide: Bool = false
    
    /// Fade out/in the first view controller, instead of moving.
    @IBInspectable var fadeFirst: Bool = true
    
    /// Clears background of view controllers so navigation background shows through.
    @IBInspectable var clearBackgrounds: Bool = true

    // MARK: - UINavigationControllerDelegate

    func navigationController(
        navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
                                        fromViewController: UIViewController,
                                        toViewController: UIViewController
        ) -> UIViewControllerAnimatedTransitioning?
    {
        let animationController = TranslationAnimationController()
        animationController.leftInset = leftInset
        animationController.rightInset = rightInset
        animationController.topInset = topInset
        animationController.belowTopGuide = belowTopGuide
        animationController.bottomInset = bottomInset
        animationController.animatePresenter = true
        animationController.isPresenting = operation != .Pop
        animationController.fadeFirst = fadeFirst
        let viewControllerAfterTransitionCount = navigationController.viewControllers.count - (operation == .Pop ? 0 : 1)
        animationController.direction = viewControllerAfterTransitionCount == 1 ? .Up : .Left
        return animationController
    }
    
    func navigationController(navigationController: UINavigationController,
                              willShowViewController viewController: UIViewController,
                                                     animated: Bool)
    {
        viewController.automaticallyAdjustsScrollViewInsets = !belowTopGuide
        if clearBackgrounds {
            viewController.view.backgroundColor = UIColor.clearColor() // TODO: Attribute
            if let tableViewController = viewController as? UITableViewController {
                tableViewController.tableView.backgroundView = nil
                tableViewController.tableView.backgroundColor = UIColor.clearColor()
            }
        }
    }

}
