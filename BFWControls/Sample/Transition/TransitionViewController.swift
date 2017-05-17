//
//  TransitionViewController.swift
//  BFWControls
//
//  Created by Andy Kim on 12/5/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//

import UIKit


class TransitionViewController: UIViewController, SegueHandler {
    
    let interactiveTransition = TranslationAnimationController()
    
    enum SegueIdentifier: String {
        case interactiveSegue
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier)
            else { return }
        switch segueIdentifier {
        case .interactiveSegue:
            let viewController = segue.destination
            viewController.transitioningDelegate = interactiveTransition
        }
    }
    
    @IBAction func handlePanGesture(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view!)
        let progress =  translation.y / pan.view!.bounds.height
        switch pan.state {
        case .began:
            interactiveTransition.isInteractive = true
            interactiveTransition.direction = .down
            performSegue(segueIdentifier: .interactiveSegue, sender: pan.view)
            break
        case .changed:
            // update progress of the transition
            interactiveTransition.update(progress)
            break
        default: // .ended, .cancelled, .failed ...
            // return flag to false and finish the transition
            interactiveTransition.isInteractive = false
            if progress > 0.2 {
                // threshold crossed: finish
                interactiveTransition.finish()
            }
            else {
                // threshold not met: cancel
                interactiveTransition.cancel()
            }
        }
    }
    
    @IBAction func unwindToTransitionWithSegue(_ segue: UIStoryboardSegue) {
        // unwind to this view controller
    }
}
