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
    
    fileprivate static let styledTextPlist = "StyledText"
    
    fileprivate static var classBundle: Bundle {
        #if TARGET_INTERFACE_BUILDER // Rendering in storyboard using IBDesignable.
            let bundle = NSBundle(forClass: self)
        #else
            let bundle = Bundle.main
        #endif
        return bundle;
    }
    
    fileprivate static var plistDict: [String: AnyObject] = {
        let plistPath = classBundle.path(forResource: styledTextPlist, ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: plistPath) as! [String: AnyObject]
        return dictionary
    }()
    
    // MARK: - Functions
    
    class func attributesForStyle(_ style: String) -> TextAttributes? {
        return attributesForSection(Section.style, key: style)
    }
    
    class func attributesForStyles(_ styles: [String]) -> TextAttributes? {
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
    
    class func attributesForLevel(_ level: Int) -> TextAttributes? {
        return attributesForSection(Section.level, key: String(level))
    }
    
    class func attributesForLookupDict(_ lookupDict: [String: AnyObject]) -> TextAttributes? {
        var attributes = TextAttributes()
        let flatDict = flatLookupDict(lookupDict)
        if let familyName = flatDict[Key.familyName] as? String {
            attributes[UIFontDescriptorFamilyAttribute] = familyName as AnyObject?
            if let weight = flatDict[Key.weight] as? CGFloat {
                let validWeight: CGFloat
                if #available(iOS 8.2, *) {
                    let fontWeight = FontWeight.fontWeightForApproximateWeight(weight)
                    validWeight = fontWeight.rawValue
                } else {
                    validWeight = weight
                }
                let traits = [UIFontWeightTrait: validWeight]
                attributes[UIFontDescriptorTraitsAttribute] = traits as AnyObject?
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
    
    fileprivate class var sections: [String] {
        return [Section.style, Section.level, Section.emphasis]
    }
    
    // TODO: Make this private by providing alernative func.
    class func attributesForSection(_ section: String, key: String) -> TextAttributes? {
        var attributes: TextAttributes?
        if let sectionDict = plistDict[section] as? [String : AnyObject],
            let lookupDict = sectionDict[key] as? [String: AnyObject]
        {
            attributes = attributesForLookupDict(lookupDict)
        }
        return attributes
    }
    
    fileprivate class func flatLookupDict(_ lookupDict: [String: AnyObject]) -> [String: AnyObject] {
        var combined = [String: AnyObject]()
        for section in sections {
            if let key = lookupDict[section],
                let sectionDict = plistDict[section] as? [String : AnyObject],
                let dict = sectionDict[String(describing: key)] as? [String: AnyObject]
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
    
    class func colorWithHexValue(_ hexValue: UInt32, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((hexValue & 0xFF00) >> 8) / 255.0,
                       blue: CGFloat(hexValue & 0xFF) / 255.0,
                       alpha: alpha)
    }
    
    class func colorWithHexString(_ hexString: String, alpha: CGFloat) -> UIColor? {
        var color: UIColor?
        let cleanHexString = hexString.replacingOccurrences(of: "#", with: "0x")
        var hexValue: UInt32 = 0
        if Scanner(string: cleanHexString).scanHexInt32(&hexValue) {
            color = colorWithHexValue(hexValue, alpha: alpha)
        }
        return color
    }
    
}

@available(iOS 8.2, *)
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
        case .ultraLight: return UIFontWeightUltraLight
        case .thin: return UIFontWeightThin
        case .light: return UIFontWeightLight
        case .regular: return UIFontWeightRegular
        case .medium: return UIFontWeightMedium
        case .semibold: return UIFontWeightSemibold
        case .bold: return UIFontWeightBold
        case .heavy: return UIFontWeightHeavy
        case .black: return UIFontWeightBlack
        }
    }
    
    var name: String {
        switch self {
        case .ultraLight: return "ultraLight"
        case .thin: return "thin"
        case .light: return "light"
        case .regular: return "regular"
        case .medium: return "medium"
        case .semibold: return "semibold"
        case .bold: return "bold"
        case .heavy: return "heavy"
        case .black: return "black"
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
    
    static func fontWeightForName(_ name: String) -> FontWeight? {
        return all.filter { $0.name == name }.first
    }
    
    static func fontWeightForApproximateWeight(_ approximateWeight: CGFloat) -> FontWeight {
        var closest: FontWeight = .medium
        for possible in all {
            if abs(possible.rawValue - approximateWeight) < abs(closest.rawValue - approximateWeight) {
                closest = possible
            }
        }
        return closest
    }

}

// TODO: move extension to separate file.
extension UIFont {
    
    func fontWithWeight(_ weight: CGFloat) -> UIFont {
        let validWeight: CGFloat
        if #available(iOS 8.2, *) {
            let fontWeight = FontWeight.fontWeightForApproximateWeight(weight)
            validWeight = fontWeight.rawValue
        } else {
            validWeight = weight
        }
        let traits = [UIFontWeightTrait: validWeight]
        let attributes: TextAttributes = [UIFontDescriptorFamilyAttribute: familyName as AnyObject, UIFontDescriptorTraitsAttribute: traits as AnyObject]
        let descriptor = UIFontDescriptor(fontAttributes: attributes)
        let font = UIFont(descriptor: descriptor, size: pointSize)
        return font
    }
    
}
