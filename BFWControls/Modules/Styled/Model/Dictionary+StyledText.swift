//
//  Dictionary+StyledText.swift
//
//  Created by Tom Brodhurst-Hill on 9/04/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import Foundation

extension Dictionary {
    
    mutating func updateWithDictionary(_ dictionary: Dictionary) {
        for (key, value) in dictionary {
            self[key] = value
        }
    }
    
}
