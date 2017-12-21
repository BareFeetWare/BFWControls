//
//  Interchangeable.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 15/8/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

public protocol Interchangeable {
    
    var textLabel: UILabel? { get }
    var detailTextLabel: UILabel? { get }
    
    var text: String? { get }
    var detailText: String? { get }

}

public extension Interchangeable where Self: UIView {
    
    var text: String? {
        get {
            return textLabel?.text
        }
        set {
            textLabel?.text = newValue
        }
    }
    
    var detailText: String? {
        get {
            return detailTextLabel?.text
        }
        set {
            detailTextLabel?.text = newValue
        }
    }

}
