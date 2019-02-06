//
//  UIView+NSLayoutConstraints.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 11/02/2016.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension UIView {
        
    func pinToSuperviewEdges() {
        pin(to: superview!,
            attributes: [.left, .right, .top, .bottom],
            secondAttributes: [.left, .right, .top, .bottom]
        )
    }
    
    func pinToSuperviewMargins() {
        pin(to: superview!,
            attributes: [.left, .right, .top, .bottom],
            secondAttributes: [.leftMargin, .rightMargin, .topMargin, .bottomMargin]
        )
    }
    
    func pinToSuperview(with inset: CGFloat) {
        pin(to: superview!,
            attributes: [.left, .right, .top, .bottom],
            secondAttributes: [.left, .right, .top, .bottom],
            constants: [inset, -inset, inset, -inset])
    }
    
    func pin(to view: UIView,
                    attributes: [NSLayoutConstraint.Attribute],
                    secondAttributes: [NSLayoutConstraint.Attribute],
                    constants: [CGFloat] = [0, 0, 0, 0])
    {
        var constraints = [NSLayoutConstraint]()
        for attributeN in 0 ..< attributes.count {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: attributes[attributeN],
                relatedBy: .equal,
                toItem: view,
                attribute: secondAttributes[attributeN],
                multiplier: 1.0,
                constant: constants[attributeN]
            )
            constraints.append(constraint)
        }
        NSLayoutConstraint.activate(constraints)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func activateOnlyConstraintsWithFirstVisible(in views: [UIView]) {
        var firstMatchedView: UIView?
        for view in views {
            let isFirstMatch = firstMatchedView == nil && !(view.isHidden)
            if let constraints = constraints(with: view) {
                if isFirstMatch {
                    firstMatchedView = view
                    NSLayoutConstraint.activate(constraints)
                } else {
                    NSLayoutConstraint.deactivate(constraints)
                }
            }
        }
    }
    
    func constraints(with view: UIView) -> [NSLayoutConstraint]? {
        return commonAncestor(with: view)?.constraints.filter { constraint in
            constraint.isBetween(item: self, otherItem: view)
        }
    }
    
    var siblingAndSuperviewConstraints: [NSLayoutConstraint]? {
        return superview?.constraints.filter { constraint in
            var include = false
            if let firstItem = constraint.firstItem as? NSObject,
                let secondItem = constraint.secondItem as? NSObject,
                firstItem == self || secondItem == self
            {
                include = true
            }
            return include
        }
    }
    
    func deactivateConstraintsIfHidden() {
        if let siblingAndSuperviewConstraints = siblingAndSuperviewConstraints {
            if isHidden {
                NSLayoutConstraint.deactivate(siblingAndSuperviewConstraints)
            } else {
                NSLayoutConstraint.activate(siblingAndSuperviewConstraints)
            }
        }
    }
    
    func addConstraint(toBypass sibling: UIView) {
        if let superview = superview,
            superview == sibling.superview,
            let gapConstraint: NSLayoutConstraint = sibling
                .constraints(with: self)?
                .first( where: {
                    [.left, .leftMargin, .leading, .leadingMargin, .top, .topMargin]
                        .contains($0.attribute(for: sibling)!)
                        && [.right, .rightMargin, .trailing, .trailingMargin, .bottom, .bottomMargin]
                            .contains($0.attribute(for: self)!)
                } ),
            let siblingToSuperConstraint: NSLayoutConstraint = sibling
                // TODO: Also handle if constraint with superview's safe area.
                .constraints(with: superview)?
                .first( where: {
                    gapConstraint.attribute(for: self)! == $0.attribute(for: $0.otherItem(if: sibling)!)!
                })
        {
            let selfToSuperConstraint = siblingToSuperConstraint.constraint(
                byReplacing: [sibling],
                with: [self])
            superview.addConstraint(selfToSuperConstraint)
            sibling.isHidden = true
            sibling.deactivateConstraintsIfHidden()
        }
    }
    
    var widthMultiplier: CGFloat? {
        get {
            return widthConstraint?.multiplier
        }
        set {
            if let widthConstraint = widthConstraint {
                if let width = newValue {
                    let newConstraint = widthConstraint.constraint(with: width)
                    superview!.removeConstraint(widthConstraint)
                    superview!.addConstraint(newConstraint)
                }
            }
        }
    }
    
    var widthConstraint: NSLayoutConstraint? {
        get {
            var widthConstraint: NSLayoutConstraint?
            if let superview = superview {
                for constraint in superview.constraints {
                    if let firstItem = constraint.firstItem as? UIView,
                        let secondItem = constraint.secondItem as? UIView
                    {
                        if [firstItem, secondItem].contains(self)
                            && [firstItem, secondItem].contains(superview)
                            && constraint.firstAttribute == .width
                            && constraint.secondAttribute == .width
                        {
                            widthConstraint = constraint
                            break
                        }
                    }
                }
            }
            return widthConstraint
        }
    }
    
}
