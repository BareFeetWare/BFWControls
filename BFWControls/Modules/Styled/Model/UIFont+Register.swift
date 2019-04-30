//
//  UIFont+Register.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 9/04/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

public extension UIFont {
    
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
    
    private static var registeredFontBundles: [Bundle] = []
    
    private static func registerFonts(in bundle: Bundle) {
        let fontURLs = bundle.urls(forResourcesWithExtensions: ["otf", "ttf"])
        CTFontManagerRegisterFontsForURLs(fontURLs as CFArray,
                                          .process,
                                          nil)
    }

}
