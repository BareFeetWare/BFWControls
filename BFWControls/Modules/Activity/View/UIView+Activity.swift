//
//  UIView+Activity.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 23/9/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

public extension UIView {
    
    public var activityIndicatorView: UIActivityIndicatorView? {
        return subviews.first { $0 is UIActivityIndicatorView } as? UIActivityIndicatorView
    }
    
    public func addActivityIndicatorView(backgroundColor: UIColor = UIColor.darkGray.withAlphaComponent(0.7)) {
        if activityIndicatorView == nil {
            let activityIndicatorView = UIActivityIndicatorView()
            activityIndicatorView.backgroundColor = backgroundColor
            activityIndicatorView.activityIndicatorViewStyle = frame.size.width > 50.0 && frame.size.height > 50.0
                ? .whiteLarge
                : .white
            activityIndicatorView.isUserInteractionEnabled = true
            activityIndicatorView.startAnimating()
            addSubview(activityIndicatorView)
            activityIndicatorView.pinToSuperviewEdges()
        }
    }
    
    @objc public func removeActivityIndicatorView() {
        activityIndicatorView?.removeFromSuperview()
    }
    
    public func addActivityIndicatorView(timeInterval: TimeInterval) {
        addActivityIndicatorView()
        let timer: Timer
        if #available(iOS 10.0, *) {
            timer = Timer(fire: Date().addingTimeInterval(timeInterval), interval: 1.0, repeats: false) { [weak self] _ in
                self?.removeActivityIndicatorView()
            }
        } else {
            timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(removeActivityIndicatorView), userInfo: self, repeats: false)
        }
        RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
    }
    
}
