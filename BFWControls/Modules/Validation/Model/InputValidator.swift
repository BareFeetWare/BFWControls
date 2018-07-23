//
//  InputValidator.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 19/6/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import Foundation

public struct InputValidator {
    
    public var validCharacterSet: CharacterSet?
    public var allowedRange: CountableClosedRange<Int>?
    
    public init(validCharacterSet: CharacterSet?,
                allowedRange: CountableClosedRange<Int>?)
    {
        self.validCharacterSet = validCharacterSet
        self.allowedRange = allowedRange
    }
    
    public enum Status {
        case tooShort
        case invalidCharacter
        case complete
        case tooLong
        
        /// String is allowed to be entered. It may or may not be complete.
        public var isAllowed: Bool {
            return [.tooShort, .complete].contains(self)
        }
    }
    
    public func changedText(text: String?, range: NSRange, replacementString string: String) -> String? {
        return (text as NSString?)?.replacingCharacters(in: range, with: string)
    }
    
    public func status(string: String?) -> Status {
        let status: Status
        if let validCharacterSet = validCharacterSet,
            !(string?.rangeOfCharacter(from: validCharacterSet.inverted) == nil)
        {
            status = .invalidCharacter
        } else if let range = allowedRange {
            switch string?.count ?? 0 {
            case 0 ..< range.lowerBound: return .tooShort
            case range: status = .complete
            default: status = .tooLong
            }
        } else {
            status = .complete
        }
        return status
    }
    
}
