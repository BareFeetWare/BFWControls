//
//  NSAttributedString+TextAttributes.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 1/5/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use and modify, without warranty.
//

import Foundation

public extension NSAttributedString {
    public func keepingTraitsAndColorButAdding(attributes: TextAttributes) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        enumerateAttributes(in: NSRange(location: 0, length: length), options: [])
        { (attributes, range, stop) in
            if let color = attributes[NSAttributedStringKey.foregroundColor] as? UIColor,
                ![UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1), .black].contains(color)
            {
                attributedString.addAttributes([NSAttributedStringKey.foregroundColor : color], range: range)
            }
            if let font = attributes[NSAttributedStringKey.font] as? UIFont,
                !font.fontDescriptor.symbolicTraits.isEmpty,
                let oldFont = attributedString.attribute(NSAttributedStringKey.font,
                                                         at: range.location,
                                                         longestEffectiveRange: nil,
                                                         in: range) as? UIFont
            {
                let newFont = oldFont.addingSymbolicTraits(font.fontDescriptor.symbolicTraits)
                attributedString.addAttributes([NSAttributedStringKey.font : newFont], range: range)
            }
        }
        return NSAttributedString(attributedString: attributedString)
    }
}
