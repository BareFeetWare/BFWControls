//
//  StyledText.swift
//
//  Created by Tom Brodhurst-Hill on 9/04/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

//TODO: Refactor to not use strings.

open class StyledText {
    
    // MARK: - Constants
    
    public struct Section {
        public static let level = "level"
        public static let emphasis = "emphasis"
        public static let style = "style"
    }
    
    struct Key {
        static let fontName = "fontName"
        static let familyName = "familyName"
        static let fontSize = "fontSize"
        static let textColor = "textColor"
        static let weight = "weight"
    }
    
    fileprivate static let styledTextPlist = "StyledText"
    
    fileprivate static var plistDict: [String : AnyObject]? = {
        guard let path = Bundle.path(forFirstResource: styledTextPlist, ofType: "plist"),
            let plistDict = NSDictionary(contentsOfFile: path) as? [String : AnyObject]
            else {
                debugPrint("StyledText: plistDict: failed")
                return nil
        }
        return plistDict
    }()
    
    // MARK: - Functions
    
    open class func attributes(for style: String) -> TextAttributes? {
        return attributes(forSection: Section.style, key: style)
    }
    
    open class func attributes(for styles: [String]) -> TextAttributes? {
        var textAttributes: TextAttributes?
        for style in styles {
            if let extraAttributes = attributes(for: style) {
                if textAttributes == nil {
                    textAttributes = TextAttributes()
                }
                textAttributes!.update(with: extraAttributes)
            }
        }
        return textAttributes
    }
    
    open class func attributes(forLevel level: Int) -> TextAttributes? {
        return attributes(forSection: Section.level, key: String(level))
    }
    
    open class func attributes(for lookupDict: [String : AnyObject]) -> TextAttributes? {
        var attributes = TextAttributes()
        let flatDict = flatLookup(dict: lookupDict)
        if let familyName = flatDict[Key.familyName] as? String,
            let fontSize = flatDict[Key.fontSize] as? CGFloat
        {
            var fontAttributes = [UIFontDescriptor.AttributeName : Any]()
            fontAttributes[.family] = familyName
            if let weight = flatDict[Key.weight] as? CGFloat {
                let fontWeight = FontWeight(approximateWeight: weight)
                let validWeight = fontWeight.rawValue
                let traits = [UIFontDescriptor.TraitKey.weight: validWeight]
                fontAttributes[.traits] = traits
            }
            let fontDescriptor = UIFontDescriptor(fontAttributes: fontAttributes)
            attributes[.font] = UIFont(descriptor: fontDescriptor, size: fontSize)
        } else if let fontName = flatDict[Key.fontName] as? String,
            let fontSize = flatDict[Key.fontSize] as? CGFloat,
            let font = UIFont(name: fontName, size: fontSize)
        {
            attributes[.font] = font
        } else if let fontName = flatDict[Key.fontName] as? String {
            debugPrint("**** error: Couldn't load UIFont(name: \(fontName)")
        } else {
            debugPrint("**** error: No value for key: \(Key.fontName)")
        }
        if let textColorString = flatDict[Key.textColor] as? String,
            // TODO: Facilitate alpha ≠ 1.0
            let textColor = UIColor(hexString: textColorString, alpha: 1.0)
        {
            attributes[.foregroundColor] = textColor
        }
        return attributes
    }
    
    // MARK: - Private variables and functions
    
    fileprivate class var sections: [String] {
        return [Section.style, Section.level, Section.emphasis]
    }
    
    // TODO: Make this private by providing alternative func.
    open class func attributes(forSection section: String, key: String) -> TextAttributes? {
        guard let sectionDict = plistDict?[section] as? [String : AnyObject],
            let lookupDict = sectionDict[key] as? [String : AnyObject]
            else { return nil }
        return attributes(for: lookupDict)
    }
    
    fileprivate class func flatLookup(dict lookupDict: [String : AnyObject]) -> [String : AnyObject] {
        guard let plistDict = plistDict
            else { return [:] }
        var combined = [String : AnyObject]()
        for section in sections {
            if let key = lookupDict[section],
                let sectionDict = plistDict[section] as? [String : AnyObject],
                let dict = sectionDict[String(describing: key)] as? [String : AnyObject]
            {
                combined.update(with: flatLookup(dict: dict))
            }
        }
        for (key, value) in lookupDict {
            if !sections.contains(key) {
                combined[key] = value
            }
        }
        return combined
    }
    
}
