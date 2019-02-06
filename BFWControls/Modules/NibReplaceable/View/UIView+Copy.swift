//
//  UIView+Copy.swift
//
//  Created by Tom Brodhurst-Hill on 6/11/2015.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

public extension UIView {
    
    // MARK: - Functions
    
    func copyConstraints(from view: UIView) {
        translatesAutoresizingMaskIntoConstraints = view.translatesAutoresizingMaskIntoConstraints
        for constraint in view.constraints {
            if var firstItem = constraint.firstItem as? UIView {
                var secondItem = constraint.secondItem as? UIView
                if firstItem == view {
                    firstItem = self
                }
                if secondItem == view {
                    secondItem = self
                }
                let copiedConstraint = NSLayoutConstraint(
                    item: firstItem,
                    attribute: constraint.firstAttribute,
                    relatedBy: constraint.relation,
                    toItem: secondItem,
                    attribute: constraint.secondAttribute,
                    multiplier: constraint.multiplier,
                    constant: constraint.constant
                )
                addConstraint(copiedConstraint)
            } else {
                debugPrint("copyConstraintsFromView: error: firstItem is not a UIView")
            }
            for axis in [NSLayoutConstraint.Axis.horizontal, NSLayoutConstraint.Axis.vertical] {
                setContentCompressionResistancePriority(view.contentCompressionResistancePriority(for: axis), for: axis)
                setContentHuggingPriority(view.contentHuggingPriority(for: axis), for: axis)
            }
        }
    }
    
    var copied: UIView {
        let copiedView = type(of: self).init(frame: frame)
        copiedView.copyProperties(from: self)
        return copiedView
    }
    
    func copied(withSubviews subviews: [UIView],
                includeConstraints: Bool) -> UIView {
        let copiedView = copied
        copiedView.copySubviews(subviews,
                                includeConstraints: includeConstraints)
        return copiedView
    }
    
    func copySubviews(_ subviews: [UIView],
                      includeConstraints: Bool)
    {
        for subview in subviews {
            let copiedSubview = type(of: subview).init(frame: frame)
            addSubview(copiedSubview)
            copiedSubview.copyProperties(from: subview)
            if includeConstraints {
                copiedSubview.copyConstraints(from: subview)
            }
            copiedSubview.copySubviews(subview.subviews,
                                       includeConstraints: includeConstraints)
        }
    }
    
    func copyAnimatableProperties(from view: UIView) {
        alpha = view.alpha
        if view.backgroundColor != nil {
            backgroundColor = view.backgroundColor
        }
        transform = view.transform
    }
    
}

public protocol Morphable {
    
    func copyProperties(from view: UIView)
    
}

extension UIView: Morphable {
    
    @objc public func copyProperties(from view: UIView) {
        copyAnimatableProperties(from: view)
        frame = view.frame
        tag = view.tag
        isUserInteractionEnabled = view.isUserInteractionEnabled
        isHidden = view.isHidden
        autoresizingMask = view.autoresizingMask
        isOpaque = view.isOpaque
    }

    @objc public func copyNonDefaultProperties(from view: UIView) {
    }

    open override func copy() -> Any {
        let copy = type(of: self).init(frame: frame)
        copy.copyProperties(from: self)
        return copy
    }
    
}

public extension UILabel {

    override func copyProperties(from view: UIView) {
        super.copyProperties(from: view)
        guard let label = view as? UILabel
            else { return }
        text = label.text
        font = label.font
        textColor = label.textColor
        // TODO: Figure out why the next two lines cause a segmentation fault in Swift 4
        /*
        shadowColor = label.shadowColor
        shadowOffset = label.shadowOffset
         */
        textAlignment = label.textAlignment
        lineBreakMode = label.lineBreakMode
        attributedText = label.attributedText
        highlightedTextColor = label.highlightedTextColor
        numberOfLines = label.numberOfLines
        adjustsFontSizeToFitWidth = label.adjustsFontSizeToFitWidth
        baselineAdjustment = label.baselineAdjustment
        minimumScaleFactor = label.minimumScaleFactor
        preferredMaxLayoutWidth = label.preferredMaxLayoutWidth
        isHighlighted = label.isHighlighted
        isEnabled = label.isEnabled
        tintColor = label.tintColor
    }
    
    override func copyNonDefaultProperties(from view: UIView) {
        super.copyNonDefaultProperties(from: view)
        guard let label = view as? UILabel
            else { return }
        if let sourceAttributedText = label.attributedText,
            let attributes = attributedText?.attributes(at: 0, effectiveRange: nil)
        {
            attributedText = sourceAttributedText.keepingTraitsAndColorButAdding(attributes: attributes)
        }
    }

}

public extension UIImageView {

    override func copyProperties(from view: UIView) {
        super.copyProperties(from: view)
        guard let imageView = view as? UIImageView
            else { return }
        image = imageView.image
        highlightedImage = imageView.highlightedImage
        isHighlighted = imageView.isHighlighted
        animationImages = imageView.animationImages
    }
    
    override func copyNonDefaultProperties(from view: UIView) {
        super.copyNonDefaultProperties(from: view)
        guard let imageView = view as? UIImageView
            else { return }
        if let sourceImage = imageView.image {
            image = sourceImage
        }
    }

}

public extension UITableViewCell {
    
    override func copyProperties(from view: UIView) {
        super.copyProperties(from: view)
        guard let cell = view as? UITableViewCell
            else { return }
        accessoryType = cell.accessoryType
        editingAccessoryType = cell.editingAccessoryType
        selectionStyle = cell.selectionStyle
        indentationLevel = cell.indentationLevel
        indentationWidth = cell.indentationWidth
        shouldIndentWhileEditing = cell.shouldIndentWhileEditing
        separatorInset = cell.separatorInset
        if #available(iOS 9, *) {
            focusStyle = cell.focusStyle
        }
    }
    
}
