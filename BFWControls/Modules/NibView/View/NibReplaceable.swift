//
//  NibReplaceable.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 4/5/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//

@objc public protocol NibReplaceable {
    
    /// Labels which should remove enclosing [] from text after awakeFromNib.
    @objc var placeholderViews: [UIView] { get }
    
}

// Implement in conforming class:

/*
open override func awakeFromNib() {
    super.awakeFromNib()
    removePlaceholders()
}
*/

public extension NibReplaceable {
    
    public func isPlaceholderString(_ string: String?) -> Bool {
        return string != nil && string!.isPlaceholder
    }
    
    /// Replace placeholders (eg [Text]) with blank text.
    internal func removePlaceholders() {
        for view in placeholderViews {
            if let label = view as? UILabel,
                let text = label.text,
                text.isPlaceholder
            {
                label.text = nil
            } else if let button = view as? UIButton {
                if button.title(for: .normal)?.isPlaceholder ?? false {
                    button.setTitle(nil, for: .normal)
                }
            }
        }
    }
    
}

private extension String {
    
    var isPlaceholder: Bool {
        return hasPrefix("[") && hasSuffix("]")
    }
    
}
