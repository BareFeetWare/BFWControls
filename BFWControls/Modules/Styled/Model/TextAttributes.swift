//
//  TextAttributes.swift
//
//  Created by Tom Brodhurst-Hill on 10/05/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import Foundation

public typealias TextAttributes = [NSAttributedString.Key : Any]

// extension TextAttributes
public extension Dictionary where Key: ExpressibleByStringLiteral, Value: AnyObject {
    
}
