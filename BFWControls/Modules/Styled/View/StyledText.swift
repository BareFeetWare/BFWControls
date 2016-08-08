//
//  StyledText.swift
//
//  Created by Tom Brodhurst-Hill on 9/04/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

class StyledText {
    
    // MARK: - Constants
    
    struct Section {
        static let level = "level"
        static let emphasis = "emphasis"
        static let style = "style"
    }
    
    struct Key {
        static let fontName = "fontName"
        static let familyName = "familyName"
        static let fontSize = "fontSize"
        static let textColor = "textColor"
        static let weight = "weight"
    }
    
    private static let styledTextPlist = "StyledText"
    
    private static var classBundle: NSBundle {
        #if TARGET_INTERFACE_BUILDER // Rendering in storyboard using IBDesignable.
            let bundle = NSBundle(forClass: self)
        #else
            let bundle = NSBundle.mainBundle()
        #endif
        return bundle;
    }
    
    private static var plistDict: [String: AnyObject] = {
        let plistPath = classBundle.pathForResource(styledTextPlist, ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: plistPath) as! [String: AnyObject]
        return dictionary
    }()
    
    // MARK: - Functions
    
    class func attributesForStyle(style: String) -> TextAttributes? {
        return attributesForSection(Section.style, key: style)
    }
    
    class func attributesForStyles(styles: [String]) -> TextAttributes? {
        var attributes: TextAttributes?
        for style in styles {
            if let extraAttributes = attributesForStyle(style) {
                if attributes == nil {
                    attributes = TextAttributes()
                }
                attributes!.updateWithDictionary(extraAttributes)
            }
        }
        return attributes
    }
    
    class func attributesForLevel(level: Int) -> TextAttributes? {
        return attributesForSection(Section.level, key: String(level))
    }
    
    class func attributesForLookupDict(lookupDict: [String: AnyObject]) -> TextAttributes? {
        var attributes = TextAttributes()
        let flatDict = flatLookupDict(lookupDict)
        if let familyName = flatDict[Key.familyName] as? String {
            attributes[UIFontDescriptorFamilyAttribute] = familyName
            if let weight = flatDict[Key.weight] as? CGFloat {
                let validWeight = weight.validWeight
                let traits = [UIFontWeightTrait: validWeight]
                attributes[UIFontDescriptorTraitsAttribute] = traits
            }
        } else if let fontName = flatDict[Key.fontName] as? String,
            let fontSize = flatDict[Key.fontSize] as? CGFloat,
            let font = UIFont(name: fontName, size: fontSize)
        {
            attributes[NSFontAttributeName] = font
        }
        if let textColorString = flatDict[Key.textColor] as? String,
            // TODO: Facilitate alpha ≠ 1.0
            let textColor = UIColor.colorWithHexString(textColorString, alpha: 1.0)
        {
            attributes[NSForegroundColorAttributeName] = textColor
        }
        return attributes
    }
    
    // MARK: - Private variables and functions
    
    private class var sections: [String] {
        return [Section.style, Section.level, Section.emphasis]
    }
    
    // TODO: Make this private by providing alernative func.
    class func attributesForSection(section: String, key: String) -> TextAttributes? {
        var attributes: TextAttributes?
        if let sectionDict = plistDict[section] as? [String : AnyObject],
            let lookupDict = sectionDict[key] as? [String: AnyObject]
        {
            attributes = attributesForLookupDict(lookupDict)
        }
        return attributes
    }
    
    private class func flatLookupDict(lookupDict: [String: AnyObject]) -> [String: AnyObject] {
        var combined = [String: AnyObject]()
        for section in sections {
            if let key = lookupDict[section],
                let sectionDict = plistDict[section] as? [String : AnyObject],
                let dict = sectionDict[String(key)] as? [String: AnyObject]
            {
                combined.updateWithDictionary(flatLookupDict(dict))
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

private extension UIColor {
    
    class func colorWithHexValue(hexValue: UInt32, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((hexValue & 0xFF00) >> 8) / 255.0,
                       blue: CGFloat(hexValue & 0xFF) / 255.0,
                       alpha: alpha)
    }
    
    class func colorWithHexString(hexString: String, alpha: CGFloat) -> UIColor? {
        var color: UIColor?
        let cleanHexString = hexString.stringByReplacingOccurrencesOfString("#", withString: "0x")
        var hexValue: UInt32 = 0
        if NSScanner(string: cleanHexString).scanHexInt(&hexValue) {
            color = colorWithHexValue(hexValue, alpha: alpha)
        }
        return color
    }
    
}

enum FontWeight {
    
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black
    
    var rawValue: CGFloat {
        switch self {
        case ultraLight: return UIFontWeightUltraLight
        case thin: return UIFontWeightThin
        case light: return UIFontWeightLight
        case regular: return UIFontWeightRegular
        case medium: return UIFontWeightMedium
        case semibold: return UIFontWeightSemibold
        case bold: return UIFontWeightBold
        case heavy: return UIFontWeightHeavy
        case black: return UIFontWeightBlack
        }
    }
    
    var name: String {
        switch self {
        case ultraLight: return "ultraLight"
        case thin: return "thin"
        case light: return "light"
        case regular: return "regular"
        case medium: return "medium"
        case semibold: return "semibold"
        case bold: return "bold"
        case heavy: return "heavy"
        case black: return "black"
        }
    }
    
    static let all: [FontWeight] = [.ultraLight,
                                    .thin,
                                    .light,
                                    .regular,
                                    .medium,
                                    .semibold,
                                    .bold,
                                    .heavy,
                                    .black]
    
    static var rawValues: [CGFloat] {
        return all.map { $0.rawValue }
    }
    
    static var names: [String] {
        return all.map { $0.name }
    }
    
    /// Arbitrary value out of range -1.0 to 1.0.
    static let notSet: CGFloat = -2.0
    
    static func weightForName(name: String) -> FontWeight? {
        return all.filter { $0.name == name }.first
    }
    
}

// TODO: move extension to separate file.
extension UIFont {
    
    func fontWithWeight(weight: CGFloat) -> UIFont {
        let traits = [UIFontWeightTrait: weight.validWeight]
        let attributes: TextAttributes = [UIFontDescriptorFamilyAttribute: familyName, UIFontDescriptorTraitsAttribute: traits]
        let descriptor = UIFontDescriptor(fontAttributes: attributes)
        let font = UIFont(descriptor: descriptor, size: pointSize)
        return font
    }
    
}

private extension CGFloat {
    
    var validWeight: CGFloat {
        let validWeights = FontWeight.rawValues
        let validWeight = closestInArray(validWeights)
        return validWeight
    }
    
    func closestInArray(array: [CGFloat]) -> CGFloat {
        var closest: CGFloat?
        for possible in array {
            if closest == nil || abs(possible - self) < abs(closest! - self) {
                closest = possible
            }
        }
        return closest!
    }
    
}
