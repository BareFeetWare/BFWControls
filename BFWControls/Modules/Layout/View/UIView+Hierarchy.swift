//
//  UIView+Hierarchy.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/7/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension UIView {
    
    func commonAncestor(with view: UIView) -> UIView? {
        var ancestor: UIView?
        if isDescendant(of: view) {
            ancestor = view
        } else if view.isDescendant(of: self) {
            ancestor = self
        } else {
            var superview: UIView? = self
            while ancestor == nil && superview != nil {
                superview = superview!.superview
                if view.isDescendant(of: superview!) {
                    ancestor = superview
                }
            }
        }
        return ancestor
    }
    
    func descendant(inOtherAncestor otherAncestorView: UIView,
                           matchingDescendant descendantView: UIView) -> UIView?
    {
        guard let indicies = descendantView.hierarchyIndexArray(in: self)
            else { return nil }
        var subview: UIView? = otherAncestorView
        for index in indicies.reversed() {
            if index < subview!.subviews.count {
                subview = subview!.subviews[index]
            } else {
                subview = nil
                break
            }
        }
        return subview
    }
    
    func hierarchyIndexArray(in ancestorView: UIView) -> [Int]? {
        var indicies: [Int]? = []
        var subview: UIView? = self
        while subview != ancestorView {
            if let index = subview?.superview?.subviews.firstIndex(of: subview!) {
                indicies?.append(index)
                subview = subview?.superview
            } else {
                indicies = nil
                break
            }
        }
        return indicies
    }
    
}
