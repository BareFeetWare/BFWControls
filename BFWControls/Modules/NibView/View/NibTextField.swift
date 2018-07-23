//
//  NibTextField.swift
//
//  Created by Tom Brodhurst-Hill on 18/05/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibTextField: UITextField {
    
    // MARK: - Variables
    
    @IBInspectable open var autoUpdateCellHeights: Bool = true
    
    /// Override in subclass
    open var contentView: NibView? {
        return nil
    }
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    open func commonInit() {
        if let contentView = contentView {
            addSubview(contentView)
            contentView.pinToSuperviewEdges()
            contentView.isUserInteractionEnabled = false
            borderStyle = .none
            absorbInnerTextField()
        }
    }
    
    fileprivate func absorbInnerTextField() {
        if let innerTextField = subviewTextField {
            innerTextField.isHidden = true
            defaultTextAttributes = innerTextField.defaultTextAttributes
        }
    }
    
    // MARK: - updateView
    
    /// Override in subclasses, calling super.
    open func updateView() {
        if autoUpdateCellHeights {
            DispatchQueue.main.async {
                // Must be performed in the queue (not in the current layoutSubviews()) for iOS 10, or cells might overlap.
                self.updateTableViewCellHeights()
            }
        }
    }
    
    open func setNeedsUpdateView() {
        needsUpdateView = true
        setNeedsLayout()
    }
    
    fileprivate var needsUpdateView = true
    
    fileprivate func updateViewIfNeeded() {
        if needsUpdateView {
            needsUpdateView = false
            updateView()
        }
    }
    
    // MARK: - UITextField
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        // TODO: Calculate the adjustment.
        let magicAdjustment: CGFloat = 50.0
        var rect: CGRect
        if let innerTextField = subviewTextField {
            rect = innerTextField.superview!.convert(innerTextField.frame, to: self)
            let adjustment = bounds.height / 2 - magicAdjustment
            rect.origin.y -= adjustment
            rect.size.height += adjustment
        } else {
            rect = super.textRect(forBounds: bounds)
        }
        return rect
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    /// Locate active text editor for debugging.
    fileprivate var fieldEditor: UIScrollView? {
        return subviews.first { $0 is UIScrollView } as? UIScrollView
    }
    
    // MARK: UIView
    
    open override func layoutSubviews() {
        // Dispatch to main queue in case layoutSubviews is called by UIKit on non main thread. Reported to happen sometimes when setNeedsLayout is called on another thread, eg by KVO. Seems to be an Apple bug.
        guard Thread.isMainThread
            else {
                fatalError("layoutSubviews() called on thread that is not main.")
        }
        updateViewIfNeeded()
        super.layoutSubviews()
    }
    
}

private extension UIView {
    
    var subviewTextField: UITextField? {
        var foundTextField: UITextField?
        for subview in subviews {
            if let textField = subview as? UITextField ?? subview.subviewTextField {
                foundTextField = textField
                break
            }
        }
        return foundTextField
    }
    
}
