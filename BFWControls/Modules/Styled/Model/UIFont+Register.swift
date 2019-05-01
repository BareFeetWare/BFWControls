//
//  UIFont+Register.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 9/04/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

public extension UIFont {
    
    static func registerFonts() {
        guard let infoDictionary = Bundle(for: BundleToken.self).infoDictionary,
            let fontFileNames = infoDictionary["UIAppFonts"] as? [String]
            else {
                print("Failed to load list of font file names in UIAppFonts in Info.plist.")
                return
        }
        fontFileNames.forEach { registerFontsInFileName($0) }
    }
    
    static func registerFontsInFileName(_ fileName: String) {
        guard let url = Bundle(for: BundleToken.self).url(forResource: fileName, withExtension: nil)
            else {
                print("Failed to locate font file: \(fileName)")
                return
        }
        let error: UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
        guard CTFontManagerRegisterFontsForURL(url as CFURL, .process, error)
            else {
                let errorDescription: String
                if let unError = error?.pointee?.takeUnretainedValue(),
                    let copiedDescription = CFErrorCopyDescription(unError)
                {
                    errorDescription = String(copiedDescription)
                } else {
                    errorDescription = "unknown"
                }
                debugPrint("Failed to register fonts in file name: \(fileName). Error: \(errorDescription)")
                return
        }
    }
    
    /// Needed just for the sake of Bundle(for: BundleToken.self).
    private final class BundleToken {}
    
    // Register if needed.
    
    static func registerFontsIfNeeded(in bundle: Bundle) {
        if !registeredFontBundles.contains(bundle) {
            registeredFontBundles += [bundle]
            registerFonts(in: bundle)
        }
    }
    
    static func registerFontsInAllBundles() {
        (Bundle.allBundles + Bundle.allFrameworks)
            .forEach { bundle in
                registerFontsIfNeeded(in: bundle)
        }
    }
    
    private static var registeredFontBundles: [Bundle] = []
    
    private static func registerFonts(in bundle: Bundle) {
        let fontURLs = bundle.urls(forResourcesWithExtensions: ["otf", "ttf"])
        CTFontManagerRegisterFontsForURLs(fontURLs as CFArray,
                                          .process,
                                          nil)
    }
    
}
