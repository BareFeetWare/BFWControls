//
//  MorphSegue.swift
//
//  Created by Tom Brodhurst-Hill on 26/10/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

// Work in progress. Unfinished.

import UIKit

class MorphSegue: UIStoryboardSegue {

    // MARK: - Public variables

    @IBOutlet lazy var fromView: UIView? = {
        return self.sourceViewController.view
    }()
    
    var duration: NSTimeInterval  = 1.0
    var animationOptions = UIViewAnimationOptions.CurveEaseInOut

    // MARK: - UIStoryboardSegue

    override func perform() {
        let destinationViewController = self.destinationViewController;
        let destinationVCView = destinationViewController.view;
        let sourceVCView = self.sourceViewController.view;
    
        // Force frames to match constraints, in case misplaced.
        destinationVCView.setNeedsLayout()
        destinationVCView.layoutIfNeeded()
    
        destinationVCView.frame = sourceVCView.frame
        if let cell = fromView as? UITableViewCell {
            cell.selected = false
        }
        var morphingView: UIView?
        var contentView: UIView?
        let isMorphingCopy = true
        if isMorphingCopy {
            // Create a copy of the view hierarchy for morphing, so the original is not changed.
            if let cell = fromView as? UITableViewCell {
                morphingView = cell.copyWithSubviews( nil,
                    includeConstraints: false)
                morphingView?.copySubviews(cell.contentView.subviews,
                    includeConstraints:false)
            } else {
                morphingView = fromView?.copyWithSubviews(fromView?.subviews,
                    includeConstraints: false)
            }
            sourceVCView.addSubview(morphingView!)
            contentView = morphingView!
        } else {
            // morphingView = self.fromView;
            // if let cell = fromView as? UITableViewCell {
            //     contentView = cell.contentView;
            // }
            // TODO: finish
        }
        if let morphingView = morphingView {
            UIView.animateWithDuration(
                duration,
                delay: 0.0,
                options: animationOptions,
                animations: {
                    morphingView.frame = sourceVCView.bounds;
                    if let _ = self.fromView as? UITableViewCell {
                        contentView?.frame = morphingView.bounds;
                    }
                    if let subviews = contentView?.subviews {
                        for subview in subviews {
                            if let destinationSubview = destinationVCView.subviewMatchingView(subview) {
                                subview.frame = destinationSubview.frame
                                subview.copyAnimatablePropertiesFromView(destinationSubview)
                            } else {
                                subview.alpha = 0.0
                            }
                        }
                    }
                })
                { finished in
                    self.sourceViewController.navigationController?.pushViewController(destinationViewController,
                        animated: false)
                    if isMorphingCopy {
                        morphingView.removeFromSuperview()
                        // morphingView.hidden = YES; // Keep it for reverse animation?
                    }
            }
        }
    }
    
}
