//
//  NibView.swift
//
//  Created by Tom Brodhurst-Hill on 27/03/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

@IBDesignable open class NibView: BFWNibView {
    
    // MARK: - Variables & Functions
    
    /// Labels which should remove enclosing [] from text after awakeFromNib.
    open var placeholderViews: [UIView]? {
        return nil
    }
    
    open func isPlaceholderString(_ string: String?) -> Bool {
        return string != nil && string!.isPlaceholder
    }
    
    // MARK: - UpdateView mechanism
    
    /// Override in subclasses and call super. Update view and subview properties that are affected by properties of this class.
    open func updateView() {
    }
    
    open func setNeedsUpdateView() {
        needsUpdateView = true
        setNeedsLayout()
    }
    
    // MARK: - Private variables and functions.
    
    /// Replace placeholders (eg [Text]) with blank text.
    fileprivate func removePlaceHolders() {
        if let views = placeholderViews {
            for view in views {
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
    
    fileprivate var needsUpdateView = true
    
    fileprivate func updateViewIfNeeded() {
        if needsUpdateView {
            needsUpdateView = false
            updateView()
        }
    }
    
    // MARK: - UIView overrides
    
    private static var sizeForKeyDictionary = [String: CGSize]()
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        let hasAlreadyLoadedFromNib = !subviews.isEmpty // TODO: More rubust test.
        return hasAlreadyLoadedFromNib
            ? self
            : viewFromNib ?? self
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        removePlaceHolders()
    }
    
    open override var intrinsicContentSize: CGSize {
        let size: CGSize
        let type = type(of: self)
        let key = NSStringFromClass(type)
        if let reuseSize = type.sizeForKeyDictionary[key] {
            size = reuseSize
        } else {
            size = type.sizeFromNib ?? .zero
            type.sizeForKeyDictionary[key] = size
        }
        return size
    }
    
    open override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            // If storyboard instance is "default" (nil) then use the backgroundColor already set in xib or awakeFromNib (ie don't set it again).
            if newValue != nil {
                super.backgroundColor = newValue
            }
        }
    }
    
    open override func layoutSubviews() {
        updateViewIfNeeded()
        super.layoutSubviews()
    }
    
}

private extension String {
    
    var isPlaceholder: Bool {
        return hasPrefix("[") && hasSuffix("]")
    }
    
}
