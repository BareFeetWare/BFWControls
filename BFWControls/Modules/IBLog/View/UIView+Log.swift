//
//  UIView+Log.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 14/10/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension Optional where Wrapped: UIView {
    
    var shortDescription: String {
        guard let self = self
            else { return "nil" }
        return self.shortDescription
    }
    
}

public extension UIView {
    
    @objc var shortDescription: String {
        let superviewConstraints = superview.flatMap { constraints(with: $0) }
        let constraintsString: String = superviewConstraints.map { String($0.count) } ?? "nil"
        return "\(type(of: self)) \(Unmanaged.passUnretained(self).toOpaque()); frame = \(self.frame); constraints to superview: \(constraintsString)"
    }
    
    func recursiveDescription(indent: Int = 0) -> String {
        return String(repeating: "  ", count: indent)
            + "\(shortDescription)\n"
            + subviews
                .map { $0.recursiveDescription(indent: indent + 1) }
                .joined()
    }
    
}

public extension UILabel {
    
    override var shortDescription: String {
        return super.shortDescription + "; text = \(self.text ?? "nil")"
    }
    
}

public extension UIImageView {
    
    override var shortDescription: String {
        return super.shortDescription + "; image = \(image == nil ? "nil" : "not nil")"
    }
    
}
