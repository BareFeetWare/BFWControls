//
//  TranslationNavigationDelegate.swift
//
//  Created by Tom Brodhurst-Hill on 7/04/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class TranslationNavigationDelegate: NSObject, UINavigationControllerDelegate {

    // MARK: - Variables

    @IBInspectable open var duration: TimeInterval = 0.3
    @IBInspectable open var leftInset: CGFloat = 0.0
    @IBInspectable open var rightInset: CGFloat = 0.0
    @IBInspectable open var topInset: CGFloat = 0.0
    @IBInspectable open var bottomInset: CGFloat = 0.0
    @IBInspectable open var belowTopGuide: Bool = false
    
    open var direction: Direction = .left
    
    @IBInspectable open var direction_: Int {
        get {
            return direction.rawValue
        }
        set {
            direction = Direction(rawValue: newValue) ?? .left
        }
    }

    open var firstDirection: Direction?
    
    @IBInspectable open var firstDirection_: Int {
        get {
            return firstDirection?.rawValue ?? direction.rawValue
        }
        set {
            firstDirection = Direction(rawValue: newValue) ?? .left
        }
    }

    /// Fade out/in the first view controller, instead of moving.
    @IBInspectable open var fadeFirst: Bool = false
    
    /// Clears background of view controllers so navigation background shows through.
    @IBInspectable open var clearBackgrounds: Bool = false

    // MARK: - UINavigationControllerDelegate

    open func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromViewController: UIViewController,
        to toViewController: UIViewController
        ) -> UIViewControllerAnimatedTransitioning?
    {
        let animationController = TranslationAnimationController()
        animationController.leftInset = leftInset
        animationController.rightInset = rightInset
        animationController.topInset = topInset
        animationController.belowTopGuide = belowTopGuide
        animationController.bottomInset = bottomInset
        animationController.animatePresenter = true
        animationController.isPresenting = operation != .pop
        animationController.fadeFirst = fadeFirst
        let viewControllerAfterTransitionCount = navigationController.viewControllers.count - (operation == .pop ? 0 : 1)
        animationController.direction = viewControllerAfterTransitionCount == 1 ? (firstDirection ?? direction) : direction
        return animationController
    }
    
    open func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool)
    {
        viewController.automaticallyAdjustsScrollViewInsets = !belowTopGuide
        if clearBackgrounds {
            viewController.view.backgroundColor = .clear // TODO: Attribute
            if let tableViewController = viewController as? UITableViewController {
                tableViewController.tableView.backgroundView = nil
                tableViewController.tableView.backgroundColor = .clear
            }
        }
    }

}
