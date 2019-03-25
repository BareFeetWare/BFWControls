//
//  NSLayoutConstraintExtensions.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 11/02/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension NSLayoutConstraint {
    
    func constraint(with multiplier: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )
        return constraint
    }
    
    func constraint(byReplacing oldItems: [NSObject], with newItems: [NSObject]) -> NSLayoutConstraint {
        let newFirstItem: AnyObject
        if let firstIndex = oldItems.firstIndex(of: firstItem as! NSObject) {
            newFirstItem = newItems[firstIndex]
        } else {
            newFirstItem = firstItem!
        }
        let newSecondItem: AnyObject?
        if let secondItem = secondItem,
            let secondIndex = oldItems.firstIndex(of: secondItem as! NSObject)
        {
            newSecondItem = newItems[secondIndex]
        } else {
            newSecondItem = self.secondItem
        }
        let constraint = NSLayoutConstraint(
            item: newFirstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: newSecondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )
        return constraint
    }
    
    func isBetween(item: NSObject, otherItem: NSObject) -> Bool {
        var isBetween = false
        if let firstItem = firstItem as? NSObject,
            let secondItem = secondItem as? NSObject
        {
            isBetween = (firstItem == item && secondItem == otherItem)
                || (firstItem == otherItem && secondItem == item)
        }
        return isBetween
    }
    
    func attribute(for view: AnyObject) -> NSLayoutConstraint.Attribute? {
        let attribute: NSLayoutConstraint.Attribute?
        if let firstItem = firstItem,
            firstItem === view
        {
            attribute = firstAttribute
        } else if let secondItem = secondItem,
            secondItem === view
        {
            attribute = secondAttribute
        } else {
            attribute = nil
        }
        return attribute
    }
    
    func otherItem(if view: UIView) -> AnyObject? {
        var otherItem: AnyObject?
        if firstItem as? UIView == view {
            otherItem = secondItem
        } else if secondItem as? UIView == view {
            otherItem = firstItem
        }
        return otherItem
    }
    
    func onlyIncludes(items: [NSObject]) -> Bool {
        var include = false
        if let firstItem = firstItem as? NSObject,
            items.contains(firstItem)
        {
            if secondItem == nil {
                include = true
            } else if let secondItem = secondItem as? NSObject,
                items.contains(secondItem)
            {
                include = true
            }
        }
        return include
    }
    
}
