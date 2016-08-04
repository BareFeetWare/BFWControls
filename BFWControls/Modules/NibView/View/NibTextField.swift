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
    
    // MARK: - Actions
    
    private func updateCellHeights() {
        if let tableView = superviewTableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    // MARK: - UITextField
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        // TODO: Calculate the adjustment.
        let magicAdjustment: CGFloat = 50.0
        var rect: CGRect
        if let innerTextField = subviewTextField {
            rect = innerTextField.superview!.convertRect(innerTextField.frame, toView: self)
            let adjustment = bounds.height / 2 - magicAdjustment
            rect.origin.y -= adjustment
            rect.size.height += adjustment
        } else {
            rect = super.textRectForBounds(bounds)
        }
        return rect
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
    /// Locate active text editor for debugging.
    private var fieldEditor: UIScrollView? {
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
        super.layoutSubviews()
        if autoUpdateCellHeights {
            updateCellHeights()
        }
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
