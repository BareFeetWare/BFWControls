//
//  UIView+Overlay.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 23/9/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension UIView {
    
    public func subview<T: UIView>(ofType: T.Type) -> T? {
        return subviews.first { $0 is T } as? T
    }
    
    public func addOverlay<T: UIView>(ofType: T.Type, backgroundColor: UIColor = UIColor.darkGray.withAlphaComponent(0.7)) {
        if subview(ofType: T.self) == nil {
            let subview = T()
            subview.backgroundColor = backgroundColor
            subview.addGestureRecognizer(UITapGestureRecognizer())
            addSubview(subview)
            if let subview = subview as? Overlayable {
                subview.customizeOverlay()
            }
            subview.pinToSuperviewEdges()
        }
    }

    public func removeOverlay<T: UIView>(ofType: T.Type) {
        subview(ofType: T.self)?.removeFromSuperview()
    }
    
    public func addOverlay<T: UIView>(
        ofType: T.Type,
        timeInterval: TimeInterval,
        backgroundColor: UIColor = UIColor.darkGray.withAlphaComponent(0.7))
    {
        addOverlay(ofType: T.self, backgroundColor: backgroundColor)
        let timer: Timer
        if #available(iOS 10.0, *) {
            timer = Timer(
                fire: Date().addingTimeInterval(timeInterval),
                interval: 1.0,
                repeats: false)
            { [weak self] _ in
                self?.removeOverlay(ofType: T.self)
            }
        } else {
            timer = Timer(
                timeInterval: timeInterval,
                target: subview(ofType: T.self)!,
                selector: #selector(removeFromSuperview),
                userInfo: nil,
                repeats: false)
        }
        RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
    }
    
}

public protocol Overlayable {
    func customizeOverlay()
}

extension UIActivityIndicatorView: Overlayable {
    public func customizeOverlay() {
        if let superview = superview {
            activityIndicatorViewStyle = superview.frame.size.width > 50.0 && superview.frame.size.height > 50.0
                ? .whiteLarge
                : .white
        }
        startAnimating()
    }
}
