//
//  StyledText.swift
//
//  Created by Tom Brodhurst-Hill on 9/04/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

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
    
    fileprivate static var plistDict: [String: AnyObject]? = {
        guard let path = Bundle.path(forFirstResource: styledTextPlist, ofType: "plist"),
            let plistDict = NSDictionary(contentsOfFile: path) as? [String: AnyObject]
            else {
                debugPrint("StyledText: plistDict: failed")
                return nil
        }
        return plistDict
    }()
    
    // MARK: - Functions
    
    public static func registerFontsIfNeeded(in bundle: Bundle) {
        if !registeredFontBundles.contains(bundle) {
            registeredFontBundles += [bundle]
            registerFonts(in: bundle)
        }
    }
    
    public static func registerFontsInAllBundles() {
        (Bundle.allBundles + Bundle.allFrameworks)
            .forEach { bundle in
                registerFontsIfNeeded(in: bundle)
        }
    }
    
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
    
    open class func attributes(for lookupDict: [String: AnyObject]) -> TextAttributes? {
        var attributes = TextAttributes()
        let flatDict = flatLookup(dict: lookupDict)
        if let familyName = flatDict[Key.familyName] as? String {
            attributes[UIFontDescriptorFamilyAttribute] = familyName as AnyObject?
            if let weight = flatDict[Key.weight] as? CGFloat {
                let fontWeight = FontWeight(approximateWeight: weight)
                let validWeight = fontWeight.rawValue
                let traits = [UIFontWeightTrait: validWeight]
                attributes[UIFontDescriptorTraitsAttribute] = traits as AnyObject?
            }
        } else if let fontName = flatDict[Key.fontName] as? String,
            let fontSize = flatDict[Key.fontSize] as? CGFloat,
            let font = UIFont(name: fontName, size: fontSize)
        {
            attributes[NSFontAttributeName] = font
        } else if let fontName = flatDict[Key.fontName] as? String {
            debugPrint("**** error: Couldn't load UIFont(name: \(fontName)")
        } else {
            debugPrint("**** error: No value for key: \(Key.fontName)")
        }
        if let textColorString = flatDict[Key.textColor] as? String,
            // TODO: Facilitate alpha ≠ 1.0
            let textColor = UIColor(hexString: textColorString, alpha: 1.0)
        {
            attributes[NSForegroundColorAttributeName] = textColor
        }
        return attributes
    }
    
    // MARK: - Private variables and functions
    
    private static var registeredFontBundles: [Bundle] = []
    
    private static func registerFonts(in bundle: Bundle) {
        let fontURLs = bundle.urls(forResourcesWithExtensions: ["otf", "ttf"])
        CTFontManagerRegisterFontsForURLs(fontURLs as CFArray,
                                          .process,
                                          nil)
    }
    
    fileprivate class var sections: [String] {
        return [Section.style, Section.level, Section.emphasis]
    }
    
    // TODO: Make this private by providing alernative func.
    open class func attributes(forSection section: String, key: String) -> TextAttributes? {
        guard let sectionDict = plistDict?[section] as? [String : AnyObject],
            let lookupDict = sectionDict[key] as? [String: AnyObject]
            else { return nil }
        return attributes(for: lookupDict)
    }
    
    fileprivate class func flatLookup(dict lookupDict: [String: AnyObject]) -> [String: AnyObject] {
        guard let plistDict = plistDict
            else { return [:] }
        var combined = [String: AnyObject]()
        for section in sections {
            if let key = lookupDict[section],
                let sectionDict = plistDict[section] as? [String : AnyObject],
                let dict = sectionDict[String(describing: key)] as? [String: AnyObject]
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

// TODO: Move extensions to separate files.

fileprivate extension Bundle {

    static func path(forFirstResource resource: String, ofType typeExtension: String) -> String? {
        var path: String?
        for bundle in Bundle.allBundles + Bundle.allFrameworks {
            if let thisPath = bundle.path(forResource: resource, ofType: typeExtension) {
                StyledText.registerFontsIfNeeded(in: bundle)
                path = thisPath
                break
            }
        }
        if path == nil {
            debugPrint("Failed to locate resource: " + resource + "." + typeExtension)
        }
        return path
    }
    
    fileprivate func urls(forResourcesWithExtensions fileExtensions: [String]) -> [URL] {
        return fileExtensions.reduce([URL]()) { (fileURLs, fileExtension) in
            let moreURLs = urls(
                forResourcesWithExtension: fileExtension,
                subdirectory: nil
            )
            return fileURLs + (moreURLs ?? [])
        }
    }
    
}

fileprivate extension UIColor {
    
    convenience init(hexValue: UInt32, alpha: CGFloat) {
        self.init(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hexValue & 0xFF00) >> 8) / 255.0,
                  blue: CGFloat(hexValue & 0xFF) / 255.0,
                  alpha: alpha)
    }
    
    convenience init?(hexString: String, alpha: CGFloat) {
        let cleanHexString = hexString.replacingOccurrences(of: "#", with: "0x")
        var hexValue: UInt32 = 0
        if Scanner(string: cleanHexString).scanHexInt32(&hexValue) {
            self.init(hexValue: hexValue, alpha: alpha)
        } else {
            return nil
        }
    }
    
}

public enum FontWeight {
    
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black
    
    public var rawValue: CGFloat {
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
    
    public static var names: [String] {
        return all.map { $0.name }
    }
    
    /// Arbitrary value out of range -1.0 to 1.0.
    public static let notSet: CGFloat = -2.0
    
    init(name: String) {
        self = FontWeight.all.first { $0.name == name }!
    }
    
    public init(approximateWeight: CGFloat) {
        self = FontWeight.all.reduce(FontWeight.medium) { closest, possible in
            return abs(possible.rawValue - approximateWeight) < abs(closest.rawValue - approximateWeight)
                ? possible : closest
        }
    }

}

public extension UIFont {
    
    func font(weight: CGFloat) -> UIFont {
        let fontWeight = FontWeight(approximateWeight: weight)
        let validWeight = fontWeight.rawValue
        let traits = [UIFontWeightTrait : validWeight]
        let fontAttributes: [String : Any] = [
            UIFontDescriptorFamilyAttribute: familyName,
            UIFontDescriptorTraitsAttribute: traits
        ]
        let descriptor = UIFontDescriptor(fontAttributes: fontAttributes)
        let font = UIFont(descriptor: descriptor, size: pointSize)
        return font
    }

    public func addingSymbolicTraits(_ symbolicTraits: UIFontDescriptorSymbolicTraits) -> UIFont {
        guard !symbolicTraits.isEmpty
            else { return self }
        var combinedTraits = fontDescriptor.symbolicTraits
        combinedTraits.insert(symbolicTraits)
        let newFontDescriptor: UIFontDescriptor
        if let combinedFontDescriptor = fontDescriptor.withSymbolicTraits(combinedTraits) {
            newFontDescriptor = combinedFontDescriptor
        } else {
            // Fallback to below for pre-iOS 10 which returns nil from above and doesn't seem to work with symbolicTraits:
            if combinedTraits.contains(.traitBold) {
                let traitsDictionary = [UIFontWeightTrait : UIFontWeightBold]
                let fontAttributes: [String : Any] = [
                    UIFontDescriptorFamilyAttribute: familyName,
                    UIFontDescriptorTraitsAttribute: traitsDictionary
                ]
                newFontDescriptor = UIFontDescriptor(fontAttributes: fontAttributes)
            } else {
                newFontDescriptor = fontDescriptor
            }
        }
        let font = UIFont(descriptor: newFontDescriptor, size: pointSize)
        return font
    }
}

public extension NSAttributedString {
    public func keepingTraitsAndColorButAdding(attributes: TextAttributes) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        enumerateAttributes(in: NSRange(location: 0, length: length), options: [])
        { (attributes, range, stop) in
            if let color = attributes[NSForegroundColorAttributeName] as? UIColor,
                color != .black
            {
                attributedString.addAttributes([NSForegroundColorAttributeName : color], range: range)
            }
            if let font = attributes[NSFontAttributeName] as? UIFont,
                !font.fontDescriptor.symbolicTraits.isEmpty,
                let oldFont = attributedString.attribute(NSFontAttributeName,
                                                         at: range.location,
                                                         longestEffectiveRange: nil,
                                                         in: range) as? UIFont
            {
                let newFont = oldFont.addingSymbolicTraits(font.fontDescriptor.symbolicTraits)
                attributedString.addAttributes([NSFontAttributeName : newFont], range: range)
            }
        }
        return NSAttributedString(attributedString: attributedString)
    }
}
