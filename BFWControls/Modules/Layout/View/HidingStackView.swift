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

    open override func layoutSubviews() {
        for subview in subviews {
            if let subview = subview as? ContentCanBeInvisible & UIView {
                subview.isHidden = subview.contentIsInvisible
            }
        }
        super.layoutSubviews()
    }
    
}

fileprivate protocol ContentCanBeInvisible {
    var contentIsInvisible: Bool { get }
}

extension UILabel: ContentCanBeInvisible {
    var contentIsInvisible: Bool {
        return text == nil
    }
}

extension UIImageView: ContentCanBeInvisible {
    var contentIsInvisible: Bool {
        return image == nil
    }
}

extension UIStackView: ContentCanBeInvisible {
    var contentIsInvisible: Bool {
        return arrangedSubviews == []
    }
}
