//
//  NSLayoutConstraintExtensions.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 11/02/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

extension UIView {
    
    func copyDescendantConstraintsFromView(fromView: UIView) {
        var fromItems: [NSObject] = [fromView]
        var toItems: [NSObject] = [self]
        var toSubviewConstraints = [NSLayoutConstraint]()
        for fromSubview in fromView.subviews {
            if let toSubview = subviewMatchingView(fromSubview) {
                fromItems.append(fromSubview)
                toItems.append(toSubview)
                toSubviewConstraints += toSubview.constraints
            }
        }
        let oldConstraints = (constraints + toSubviewConstraints).filter { constraint in
            constraint.onlyIncludesItems(toItems)
        }
        let copiedConstraints = oldConstraints.map { oldConstraint in
            oldConstraint.constraintByReplacingItems(toItems, withNewItems: fromItems)
        }
        NSLayoutConstraint.deactivateConstraints(oldConstraints)
        NSLayoutConstraint.activateConstraints(copiedConstraints)
    }

    func pinToSuperviewEdges() {
        pinToView(superview!,
            attributes: [.Left, .Right, .Top, .Bottom],
            secondAttributes: [.Left, .Right, .Top, .Bottom]
        )
    }

    func pinToSuperviewMargins() {
        pinToView(superview!,
            attributes: [.Left, .Right, .Top, .Bottom],
            secondAttributes: [.LeftMargin, .RightMargin, .TopMargin, .BottomMargin]
        )
    }
    
    func pinToSuperviewWithInset(inset: CGFloat) {
        pinToView(superview!,
            attributes: [.Left, .Right, .Top, .Bottom],
            secondAttributes: [.Left, .Right, .Top, .Bottom],
            constants: [inset, -inset, inset, -inset])
    }
    
    func pinToView(view: UIView,
        attributes: [NSLayoutAttribute],
        secondAttributes: [NSLayoutAttribute],
        constants: [CGFloat] = [0, 0, 0, 0])
    {
        var constraints = [NSLayoutConstraint]()
        for attributeN in 0 ..< attributes.count {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: attributes[attributeN],
                relatedBy: .Equal,
                toItem: view,
                attribute: secondAttributes[attributeN],
                multiplier: 1.0,
                constant: constants[attributeN]
            )
            constraints.append(constraint)
        }
        NSLayoutConstraint.activateConstraints(constraints)
    }

}

extension NSLayoutConstraint {
    
    func constraintWithMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )
        return constraint;
    }
    
    func constraintByReplacingItems(oldItems: [NSObject], withNewItems newItems: [NSObject]) -> NSLayoutConstraint {
        let firstIndex = oldItems.indexOf(self.firstItem as! NSObject)!
        let firstItem = newItems[firstIndex]
        var newSecondItem: NSObject?
        if let secondItem = secondItem {
            if let secondIndex = oldItems.indexOf(secondItem as! NSObject) {
                newSecondItem = newItems[secondIndex]
            }
        }
        let constraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: newSecondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )
        return constraint
    }
    
    func otherItemIfView(view: UIView) -> AnyObject? {
        var otherItem: AnyObject?
        if firstItem as? UIView == view {
            otherItem = secondItem
        } else if secondItem as? UIView == view {
            otherItem = firstItem
        }
        return otherItem
    }
    
    func onlyIncludesItems(items: [NSObject]) -> Bool {
        var include = false
        if let firstItem = firstItem as? NSObject where items.contains(firstItem) {
            if secondItem == nil {
                include = true
            } else if let secondItem = secondItem as? NSObject where items.contains(secondItem) {
                include = true
            }
        }
        return include
    }
    
}