//
//  UIImage+BFW.swift
//  BFWControls
//
//  Created by Charlotte Tortorella on 19/4/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//

import Foundation

extension UIImage {
    func masking(_ image: UIImage) -> UIImage? {
        guard let maskRef = image.cgImage,
            let dataProvider = maskRef.dataProvider
            else { return nil }
        let mask = CGImage(maskWidth: maskRef.width,
                           height: maskRef.height,
                           bitsPerComponent: maskRef.bitsPerComponent,
                           bitsPerPixel: maskRef.bitsPerPixel,
                           bytesPerRow: maskRef.bytesPerRow,
                           provider: dataProvider,
                           decode: nil,
                           shouldInterpolate: false)
        return mask
            .flatMap { self.cgImage?.masking($0) }
            .flatMap(UIImage.init(cgImage:))
    }

    static func snapshot(of view: UIView, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
