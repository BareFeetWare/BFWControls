//
//  UIView+Overlay.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 23/9/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public protocol Overlay where Self: UIView {}

public extension UIView {
    
    func firstSubview<T: UIView>(ofType: T.Type) -> T? {
        return subviews.first { $0 is T } as? T
    }
    
    var overlay: (UIView & Overlay)? {
        return subviews.first { $0 is Overlay } as? UIView & Overlay
    }
    
    func addOneOverlay(_ overlay: (UIView & Overlay)?) {
        subviews.filter { $0 is Overlay && type(of: $0) != type(of: overlay) }
            .forEach { $0.removeFromSuperview() }
        if let overlay = overlay, self.overlay == nil {
            addSubview(overlay)
            overlay.pinToSuperviewEdges()
        }
    }
    
    func addOneOverlay<T: Overlay>(ofType overlayType: T.Type?) {
        subviews.filter { $0 is Overlay && type(of: $0) != overlayType }
            .forEach { $0.removeFromSuperview() }
        if overlayType != nil, self.overlay == nil {
            let overlay = T()
            addSubview(overlay)
            overlay.pinToSuperviewEdges()
        }
    }
    
    @objc func removeOverlays() {
        subviews.filter { $0 is Overlay }
            .forEach { $0.removeFromSuperview() }
    }
    
    func addOneOverlay(_ overlay: UIView & Overlay, timeInterval: TimeInterval) {
        addOneOverlay(overlay)
        let timer: Timer
        if #available(iOS 10.0, *) {
            timer = Timer(
                fire: Date().addingTimeInterval(timeInterval),
                interval: 0.0,
                repeats: false)
            { _ in
                self.removeOverlays()
            }
        } else {
            timer = Timer(
                timeInterval: timeInterval,
                target: self,
                selector: #selector(removeOverlays),
                userInfo: nil,
                repeats: false)
        }
        RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
    }
    
}
