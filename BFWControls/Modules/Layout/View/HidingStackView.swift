//
//  HidingStackView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 1/10/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

/// A stack view that hides any subviews that have invisible contents (eg UILabel.text == nil and UIImageView.image == nil) or a UIStackView subview that has all of its subviews hidden. When a stack view has a hidden subview, it removes it from the arrangedSubviews, so the space it occupied is freed, essentially shrinking any unused space.
@IBDesignable open class HidingStackView: UIStackView {
    
    // MARK: - Variables
    
    private var observations: Set<NSKeyValueObservation> = []
    
    // MARK: - Functions
    
    private func observeView(_ view: UIView) {
        if let label = view as? UILabel {
            observations.insert(
                label.observe(\.text) { [weak self] (_, _) in
                    self?.updateSubview(view)
                }
            )
        } else if let imageView = view as? UIImageView {
            observations.insert(
                imageView.observe(\.image) { [weak self] (_, _) in
                    self?.updateSubview(view)
                }
            )
        }
    }
    
    private func updateSubview(_ subview: UIView) {
        if let subview = subview as? ContentCanBeInvisible & UIView {
            subview.isHidden = subview.isInvisibleContent
            isHidden = isInvisibleContent
        }
    }
    
    // MARK: - UIView
    
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        observeView(view)
    }
    
}

fileprivate protocol ContentCanBeInvisible {
    var isInvisibleContent: Bool { get }
}

extension UILabel: ContentCanBeInvisible {
    var isInvisibleContent: Bool {
        return text == nil
    }
}

extension UIImageView: ContentCanBeInvisible {
    var isInvisibleContent: Bool {
        return image == nil
    }
}

extension UIStackView: ContentCanBeInvisible {
    var isInvisibleContent: Bool {
        return arrangedSubviews.first { !$0.isHidden } == nil
    }
}
