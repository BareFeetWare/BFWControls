//
//  MorphSegue.swift
//
//  Created by Tom Brodhurst-Hill on 26/10/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

// Work in progress. Unfinished.

import UIKit

class MorphSegue: UIStoryboardSegue {
    
    @IBOutlet lazy var fromView: UIView! = {
        return self.sourceViewController.view
    }()
    
    var duration: NSTimeInterval = 1.0
    var animationOptions: UIViewAnimationOptions = UIViewAnimationOptions.CurveEaseInOut
    
    // MARK: - Move to another class.
    
    func constraintsReplacingConstraints(
        oldConstraints: [NSLayoutConstraint],
        views oldViews: [UIView],
        withViews views: [UIView]
        ) -> [NSLayoutConstraint]
    {
        var constraints = [NSLayoutConstraint]()
        for oldConstraint in oldConstraints {
            if var firstItem = oldConstraint.firstItem as? UIView,
                var secondItem = oldConstraint.secondItem as? UIView
            {
                var didReplace = false
                if oldViews.contains(firstItem) {
                    firstItem = views[oldViews.indexOf(firstItem)!];
                    didReplace = true
                }
                if oldViews.contains(secondItem) {
                    secondItem = views[oldViews.indexOf(secondItem)!]
                    didReplace = true
                }
                if didReplace {
                    let constraint = NSLayoutConstraint(
                        item: firstItem,
                        attribute: oldConstraint.firstAttribute,
                        relatedBy: oldConstraint.relation,
                        toItem: secondItem,
                        attribute: oldConstraint.secondAttribute,
                        multiplier: oldConstraint.multiplier,
                        constant: oldConstraint.constant
                    )
                    constraints.append(constraint)
                }
            }
        }
        return constraints
    }
    
    // MARK: - UIStoryboardSegue
    
    override func perform() {
        let destinationVCView = destinationViewController.view
        let sourceVCView = sourceViewController.view
        
        // Force frames to match constraints, in case misplaced.
        destinationVCView.setNeedsLayout()
        destinationVCView.layoutIfNeeded()
        
        destinationVCView.frame = sourceVCView.frame;
        
        if let cell = fromView as? UITableViewCell {
            cell.selected = false
        }
        
        var morphingView: UIView?
        var contentView: UIView?
        let isMorphingCopy = true
        if isMorphingCopy {
            // Create a copy of the view hierarchy for morphing, so the original is not changed.
            if let cell = fromView as? UITableViewCell {
                morphingView = cell.copyWithSubviews(nil, includeConstraints: true)
                morphingView?.copySubviews(cell.contentView.subviews, includeConstraints: true)
            } else {
                morphingView = fromView.copyWithSubviews(fromView.subviews, includeConstraints: true)
            }
            if let morphingView = morphingView {
                sourceVCView.addSubview(morphingView)
                contentView = morphingView
            }
        } else {
            morphingView = fromView
            if let cell = fromView as? UITableViewCell {
                contentView = cell.contentView
            }
            // TODO: finish
        }
        
        // Add destination constraints, which will animate frames when layout is updated, inside animation block below.
        var sourceConstraints = [NSLayoutConstraint]()
        var destinationConstraints = [NSLayoutConstraint]()
        var sourceSubviews = [UIView]()
        var destinationSubviews = [UIView]()
        sourceConstraints.appendContentsOf(sourceVCView.constraints)
        destinationConstraints.appendContentsOf(destinationVCView.constraints)
        sourceSubviews.append(sourceVCView) // TODO: add top/bottom guides
        destinationSubviews.append(destinationVCView) // TODO: add top/bottom guides
        for sourceSubview in contentView!.subviews {
            if let destinationSubview = destinationVCView.subviewMatchingView(sourceSubview) {
                if sourceSubview.tag == 1 { // testing using tag
                    sourceSubviews.append(sourceSubview)
                    destinationSubviews.append(destinationSubview)
                    for constraint in sourceVCView.constraints {
                        if constraint.firstItem as? UIView == sourceSubview || constraint.secondItem as? UIView == sourceSubview {
                            sourceConstraints.append(constraint)
                        }
                    }
                    for constraint in destinationVCView.constraints {
                        if constraint.firstItem as? UIView == destinationSubview || constraint.secondItem as? UIView == destinationSubview {
                            destinationConstraints.append(constraint)
                        }
                    }
                }
            }
        }
        let constraints = constraintsReplacingConstraints(
            destinationConstraints,
            views: destinationSubviews,
            withViews: sourceSubviews
        )
        NSLayoutConstraint.deactivateConstraints(sourceConstraints)
        NSLayoutConstraint.activateConstraints(constraints)
        
        if let morphingView = morphingView {
            UIView.animateWithDuration(
                duration,
                delay: 0.0,
                options: animationOptions,
                animations: { () -> Void in
                    // morphingView.frame = sourceVCView.bounds;
                    morphingView.setNeedsLayout()
                    morphingView.layoutIfNeeded()
                    if let contentView = contentView {
                        if let _ = self.fromView as? UITableViewCell {
                            contentView.frame = morphingView.bounds
                        }
                        for subview in contentView.subviews {
                            if let destinationSubview = destinationVCView.subviewMatchingView(subview) {
                                // subview.frame = destinationSubview.frame;
                                subview.copyAnimatablePropertiesFromView(destinationSubview)
                            } else {
                                subview.alpha = 0.0;
                            }
                        }
                    }
                }) { (finished) -> Void in
                    self.sourceViewController.navigationController?.pushViewController(self.destinationViewController, animated: true)
                    if isMorphingCopy {
                        morphingView.removeFromSuperview()
                        // morphingView.hidden = YES; // Keep it for reverse animation?
                    }
            }
        }
    }

}
