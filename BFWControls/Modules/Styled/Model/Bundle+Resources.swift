//
//  Bundle+Resources.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 9/04/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

public extension Bundle {
    
    static func path(forFirstResource resource: String, ofType typeExtension: String) -> String? {
        var path: String?
        for bundle in Bundle.allBundles + Bundle.allFrameworks {
            if let thisPath = bundle.path(forResource: resource, ofType: typeExtension) {
                path = thisPath
                break
            }
        }
        if path == nil {
            debugPrint("Failed to locate resource: " + resource + "." + typeExtension)
        }
        return path
    }
    
    func urls(forResourcesWithExtensions fileExtensions: [String]) -> [URL] {
        return fileExtensions.reduce([URL]()) { (fileURLs, fileExtension) in
            let moreURLs = urls(
                forResourcesWithExtension: fileExtension,
                subdirectory: nil
            )
            return fileURLs + (moreURLs ?? [])
        }
    }

}
