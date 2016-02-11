//
//  NSLayoutConstraintExtensions.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 11/02/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    func constraintWithMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier:multiplier,
            constant: constant
        )
        return constraint;
    }

    class func constraintsReplacingConstraints(
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

    class func copyDescendantConstraintsFromSourceView(sourceView: UIView, toDestinationView destinationView: UIView) {
        var sourceConstraints = sourceView.constraints
        var destinationConstraints = destinationView.constraints
        var sourceSubviews = [sourceView] // TODO: add top/bottom guides
        var destinationSubviews = [destinationView] // TODO: add top/bottom guides
//        for sourceSubview in contentView!.subviews {
        for sourceSubview in sourceView.subviews {
            if sourceSubview.tag == 1 { // Testing: only do the object that is tagged with "1"
                if let destinationSubview = destinationView.subviewMatchingView(sourceSubview) {
                    sourceSubviews.append(sourceSubview)
                    destinationSubviews.append(destinationSubview)
                    for constraint in sourceView.constraints {
                        if constraint.firstItem as? UIView == sourceSubview || constraint.secondItem as? UIView == sourceSubview {
                            sourceConstraints.append(constraint)
                        }
                    }
                    for constraint in destinationView.constraints {
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
//        NSLayoutConstraint.activateConstraints(constraints)
        destinationView.addConstraints(constraints)
    }
    
}