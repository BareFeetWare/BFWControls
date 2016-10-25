//
//  NibTextField.swift
//
//  Created by Tom Brodhurst-Hill on 18/05/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

class NibTextField: UITextField {

    // MARK: - Variables
    
    @IBInspectable var autoUpdateCellHeights: Bool = true
    
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
    func updateView() {
    }
    
    func setNeedsUpdateView() {
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
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
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
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    /// Locate active text editor for debugging.
    fileprivate var fieldEditor: UIScrollView? {
        var fieldEditor: UIScrollView?
        for subview in subviews {
            if let possible = subview as? UIScrollView {
                fieldEditor = possible
                break
            }
        }
        return fieldEditor
    }
    
    // MARK: UIView
    
    override func layoutSubviews() {
        updateViewIfNeeded()
        if autoUpdateCellHeights {
            updateTableViewCellHeights()
        }
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
