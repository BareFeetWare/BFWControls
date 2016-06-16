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
    
    private var innerTextField: UITextField? {
        var innerTextField: UITextField?
        if let contentView = contentView {
            for subview in contentView.subviews {
                if let textField = subview as? UITextField {
                    innerTextField = textField
                    break
                }
            }
        }
        return innerTextField
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
            innerTextField?.hidden = true
            if let attributes = innerTextField?.defaultTextAttributes {
                defaultTextAttributes = attributes
            }
            borderStyle = .None
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
        return rect
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        let rect = innerTextField?.frame ?? super.editingRectForBounds(bounds)
        return rect
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
