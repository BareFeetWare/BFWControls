//
//  NibView.swift
//
//  Created by Tom Brodhurst-Hill on 27/03/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

@IBDesignable class NibView: UIView {

    // MARK: - Variables & Functions
    
    /// Labels which should remove enclosing [] from text after awakeFromNib.
    var placeholderViews: [UIView]? {
        return nil
    }

    func isPlaceholderString(_ string: String?) -> Bool {
        return string != nil && string!.isPlaceholder
    }
    
    // MARK: - UpdateView mechanism
    
    /// Override in subclasses and call super. Update view and subview properties that are affected by properties of this class.
    func updateView() {
    }
    
    func setNeedsUpdateView() {
        needsUpdateView = true
        setNeedsLayout()
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if super.subviews.count == 0 { // Prevents loading nib in nib itself.
            let nibView = fromNib()!
            nibView.frame = bounds
            addSubview(nibView)
            nibView.pinToSuperviewEdges()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Replaces an instance of view in a storyboard or xib with the full subview structure from its own xib.
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        let hasAlreadyLoadedFromNib = subviews.count > 0 // TODO: More rubust test.
        let view = hasAlreadyLoadedFromNib ? self : fromNib()
        return view
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        removePlaceHolders()
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
    
    // MARK: - Caching
    
    static var sizeForKeyDictionary = [String: CGSize]()

    // MARK: - UIView
    
    override func layoutSubviews() {
        updateViewIfNeeded()
        super.layoutSubviews()
    }
    
    override var intrinsicContentSize: CGSize {
        let size: CGSize
        let type = type(of: self)
        let key = NSStringFromClass(type)
        if let reuseSize = type.sizeForKeyDictionary[key] {
            size = reuseSize
        } else {
            size = type.sizeFromNib()
            type.sizeForKeyDictionary[key] = size
        }
        return size
    }
    
    override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            // If storyboard instance is "default" (nil) then use the backgroundColor already set in xib or awakeFromNib (ie don't set it again).
            if let backgroundColor = newValue {
                super.backgroundColor = backgroundColor
            }
        }
    }

}

private extension String {
    
    var isPlaceholder: Bool {
        return hasPrefix("[") && hasSuffix("]")
    }
    
}
