//
//  UIFont+Weight.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 9/04/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

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
        case .ultraLight: return UIFont.Weight.ultraLight.rawValue
        case .thin: return UIFont.Weight.thin.rawValue
        case .light: return UIFont.Weight.light.rawValue
        case .regular: return UIFont.Weight.regular.rawValue
        case .medium: return UIFont.Weight.medium.rawValue
        case .semibold: return UIFont.Weight.semibold.rawValue
        case .bold: return UIFont.Weight.bold.rawValue
        case .heavy: return UIFont.Weight.heavy.rawValue
        case .black: return UIFont.Weight.black.rawValue
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
        let traits = [UIFontDescriptor.TraitKey.weight : validWeight]
        let fontAttributes: [UIFontDescriptor.AttributeName : Any] = [
            .family : familyName,
            .traits : traits
        ]
        let descriptor = UIFontDescriptor(fontAttributes: fontAttributes)
        let font = UIFont(descriptor: descriptor, size: pointSize)
        return font
    }
    
    func addingSymbolicTraits(_ symbolicTraits: UIFontDescriptor.SymbolicTraits) -> UIFont {
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
                let traitsDictionary = [UIFontDescriptor.TraitKey.weight : UIFont.Weight.bold]
                let fontAttributes: [UIFontDescriptor.AttributeName : Any] = [
                    .family : familyName,
                    .traits : traitsDictionary
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
