//
//  BFWMorphStoryboardSegue.m
//
//  Created by Tom Brodhurst-Hill on 26/10/2015.
//  Copyright (c) 2015 BareFeetWare. Free to use and modify, without warranty.
//

// Work in progress. Unfinished.

import UIKit

class BFWMorphStoryboardSegue: UIStoryboardSegue {
    
    @IBOutlet weak var fromView: UIView?
    var usedFromView: UIView {
        get {
            return self.fromView ?? self.sourceViewController.view
        }
    }
    
    var duration: NSTimeInterval = 1.0
    var animationOptions = UIViewAnimationOptions.CurveEaseInOut
        
    //MARK - move to another class

    func constraintsReplacingConstraints(
        constraints: [NSLayoutConstraint],
        oldViews: [UIView],
        newViews: [UIView]
        ) -> [NSLayoutConstraint]
{
    var constraints = [NSLayoutConstraint]()
    for oldConstraint in constraints {
        var didReplace = false;
        var firstItem : UIView?
        var secondItem : UIView?
        if let firstIndex = oldViews.indexOf(oldConstraint.firstItem as! UIView) {
            if let matchedFirstItem = newViews[firstIndex] as UIView? {
                firstItem = matchedFirstItem
                didReplace = true
            }
        }
        if let secondIndex = oldViews.indexOf(oldConstraint.secondItem as! UIView) {
            if let matchedSecondItem = newViews[secondIndex] as UIView? {
                secondItem = matchedSecondItem
                didReplace = true
            }
        }
        if (didReplace) {
            let constraint = NSLayoutConstraint(
                item: firstItem!,
                attribute: oldConstraint.firstAttribute,
                relatedBy: oldConstraint.relation,
                toItem: secondItem,
                attribute: oldConstraint.secondAttribute,
                multiplier: oldConstraint.multiplier,
                constant: oldConstraint.constant)
            constraints += [constraint]
        }
    }
    return constraints;
}

//MARK - UIStoryboardSegue

    override func perform() {
        let destinationVCView = destinationViewController.view
        let sourceVCView = self.sourceViewController.view
        
        // Force frames to match constraints, in case misplaced.
        destinationVCView.setNeedsLayout()
        destinationVCView.layoutIfNeeded()
        
        destinationVCView.frame = sourceVCView.frame;
        let isMorphingCopy = true
        var morphingView: UIView?
        var contentView: UIView?
        if let cell = usedFromView as? UITableViewCell {
            cell.selected = false;
        }
        
        if isMorphingCopy {
            // Create a copy of the view hierarchy for morphing, so the original is not changed.
            if let cell = usedFromView as? UITableViewCell {
                morphingView = cell.copyWithSubviews(nil, includeConstraints: true)
                morphingView?.copySubviews(cell.contentView.subviews, includeConstraints: true)
            } else {
                morphingView = usedFromView.copyWithSubviews(usedFromView.subviews, includeConstraints: true)
            }
            sourceVCView.addSubview(morphingView!)
            contentView = morphingView;
        } else {
            morphingView = self.usedFromView;
            if let cell = usedFromView as? UITableViewCell {
                contentView = cell.contentView;
            }
            // TODO: finish
        }
        
        // Add destination constraints, which will animate frames when layout is updated, inside animation block below.
        var sourceConstraints = [NSLayoutConstraint]()
        var destinationConstraints = [NSLayoutConstraint]()
        var sourceSubviews = [UIView]()
        var destinationSubviews = [UIView]()
        sourceConstraints += sourceVCView.constraints
        destinationConstraints += destinationVCView.constraints
        sourceSubviews += [sourceVCView]; // TODO: add top/bottom guides
        destinationSubviews += [destinationVCView] // TODO: add top/bottom guides
        for sourceSubview in contentView!.subviews {
            if let destinationSubview = destinationVCView.subviewMatchingView(sourceSubview) {
                if sourceSubview.tag == 1 { // testing using tag
                    sourceSubviews += [sourceSubview]
                    destinationSubviews += [destinationSubview]
                    for constraint in sourceVCView.constraints {
                        if constraint.firstItem as? NSObject == sourceSubview || constraint.secondItem as? NSObject == sourceSubview {
                            sourceConstraints += [constraint]
                        }
                    }
                }
                for constraint in destinationVCView.constraints {
                    if constraint.firstItem as? NSObject == destinationSubview || constraint.secondItem as? NSObject == destinationSubview {
                        destinationConstraints += [constraint]
                    }
                }
            }
        }
        let constraints = constraintsReplacingConstraints(destinationConstraints,
            oldViews: destinationSubviews,
            newViews: sourceSubviews)
        if #available(iOS 8.0, *) {
            NSLayoutConstraint.deactivateConstraints(sourceConstraints)
            NSLayoutConstraint.activateConstraints(constraints)
        } else {
            // Fallback on earlier versions
        }
        
        UIView.animateWithDuration(duration,
            delay: 0.0,
            options: animationOptions,
            animations: {
                //                         morphingView.frame = sourceVCView.bounds;
                morphingView?.setNeedsLayout()
                morphingView?.layoutIfNeeded()
                if let _ = self.usedFromView as? UITableViewCell {
                    contentView?.frame = morphingView!.bounds
                }
                for subview in contentView!.subviews {
                    if let destinationSubview = destinationVCView.subviewMatchingView(subview) {
                        // subview.frame = destinationSubview.frame;
                        subview.copyAnimatablePropertiesFromView(destinationSubview)
                    } else {
                        subview.alpha = 0.0
                    }
                }
            } )
            { (Bool) -> Void in
                self.sourceViewController.navigationController?.pushViewController(self.destinationViewController,
                    animated: false)
                if isMorphingCopy {
                    morphingView?.removeFromSuperview()
                    // morphingView.hidden = YES; // Keep it for reverse animation?
                }
        }
    }
}