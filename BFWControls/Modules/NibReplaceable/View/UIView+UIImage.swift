//
//  UIView+UIImage.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 17/7/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use and modify, without warranty.
//

import UIKit

public extension UIView {
    
    // Based on https://gist.github.com/stakes/de024878ce3cc43d7ee6
    func image(size: CGSize? = nil) -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: size ?? bounds.size)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(size ?? bounds.size)
            let context = UIGraphicsGetCurrentContext()!
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        }
    }
    
}
