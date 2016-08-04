//
//  NibTextField.swift
//
//  Created by Tom Brodhurst-Hill on 18/05/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

class NibTextField: UITextField {

    // MARK: - Variables
    
    /// Override in subclass
    var contentView: NibView? {
        return nil
    }
        
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        if let contentView = contentView {
            addSubview(contentView)
            contentView.pinToSuperviewEdges()
            contentView.userInteractionEnabled = false
            borderStyle = .None
            absorbInnerTextField()
        }
    }
    
    private func absorbInnerTextField() {
        if let innerTextField = subviewTextField {
            innerTextField.hidden = true
            defaultTextAttributes = innerTextField.defaultTextAttributes
        }
    }
    
    // MARK: - updateView

    /// Override in subclasses, calling super.
    func updateView() {
    }
    
    func setNeedsUpdateView() {
        needsUpdateView = true
        setNeedsLayout()
    }
    
    private var needsUpdateView = true
    
    private func updateViewIfNeeded() {
        if needsUpdateView {
            needsUpdateView = false
            updateView()
        }
    }
    
    // MARK: - UITextField
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        let rect = innerTextField?.frame ?? super.textRectForBounds(bounds)
        var rect: CGRect
        if let innerTextField = subviewTextField {
            rect = innerTextField.superview!.convertRect(innerTextField.frame, toView: self)
        } else {
            rect = super.textRectForBounds(bounds)
        }
        return rect
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
    // MARK: UIView
    
    override func intrinsicContentSize() -> CGSize {
        return contentView?.intrinsicContentSize() ?? super.intrinsicContentSize()
    }
    
    override func layoutSubviews() {
        updateViewIfNeeded()
        super.layoutSubviews()
    }

}

private extension UIView {
    
    var subviewTextField: UITextField? {
        var textField: UITextField?
        for subview in subviews {
            if let possible = subview as? UITextField {
                textField = possible
            } else if let possible = subview.subviewTextField {
                textField = possible
            }
            if textField != nil {
                break
            }
        }
        return textField
    }
    
}
