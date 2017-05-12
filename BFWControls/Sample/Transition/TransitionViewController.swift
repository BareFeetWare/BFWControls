//
//  TransitionViewController.swift
//  BFWControls
//
//  Created by Andy Kim on 12/5/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//

import UIKit


class TransitionViewController: UIViewController {

	let interactiveTransition = TranslationAnimationController()
	
	enum SegueIdentifier: String {
		case interactiveSegue
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let segueIdentifier = SegueIdentifier(rawValue: segue.identifier!)
			else { return }
		switch segueIdentifier {
		case .interactiveSegue:
			let viewController = segue.destination
			viewController.transitioningDelegate = interactiveTransition
		}
    }


	@IBAction func handlePanGesture(_ pan: UIPanGestureRecognizer) {
		let translation = pan.translation(in: pan.view!)
		let d =  translation.y / pan.view!.bounds.height
		switch pan.state {
		case .began:
			interactiveTransition.isInteractive = true
			interactiveTransition.direction = .down
			performSegue(withIdentifier: SegueIdentifier.interactiveSegue.rawValue, sender: self)
			break
		case .changed:
			// update progress of the transition
			interactiveTransition.update(d)
			break
		default: // .ended, .cancelled, .failed ...
			// return flag to false and finish the transition
			interactiveTransition.isInteractive = false
			if d > 0.2 {
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
