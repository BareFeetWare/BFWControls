//
//  NibContainer.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/3/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

/// Abstract superclass. Subclass with an implementation of contentSubview.
public protocol NibContainer {
    
    /// View that will be inserted as a subview in the contentView.
    var contentSubview: UIView { get }
    
    /// View that will contain the nibView as a subview.
    var contentView: UIView { get }
    
    /// Call this function from inits to insert the contentSubview in the contentView and pin it with constraints.
    func addContentSubview()
    
}

public protocol NibViewProvider {
    
    var nibView: NibView { get }
    
}

public extension NibContainer {
    
    public var contentSubview: UIView {
        guard let nibView = (self as? NibViewProvider)?.nibView
            else { fatalError("Concrete subclass must conform to NibViewProvider") }
        return nibView
    }
    
    public func addContentSubview() {
        contentView.addSubview(contentSubview)
        contentSubview.pinToSuperviewEdges()
    }
    
}
