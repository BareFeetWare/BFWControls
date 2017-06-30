//
//  UIView+Copy.swift
//
//  Created by Tom Brodhurst-Hill on 6/11/2015.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

public extension UIView {
    
    // MARK: - Class variables
    
    public static var bundle: Bundle? {
        let isInterfaceBuilder: Bool
        #if TARGET_INTERFACE_BUILDER // Rendering in storyboard using IBDesignable.
            isInterfaceBuilder = true
        #else
            isInterfaceBuilder = false
        #endif
        let bundle = isInterfaceBuilder
            ? Bundle(for: self)
                // TODO: Dynamic strings:
            : moduleName == "BFWControls"
            ? Bundle(identifier: "com.barefeetware.BFWControls")
            : Bundle.main
        return bundle
    }
    
    static var classNameComponents: [String] {
        let fullClassName = NSStringFromClass(self) // Note: String(describing: self) does not include the moduleName prefix.
        return fullClassName.components(separatedBy: ".")
    }
    
    static var nibName: String {
        // Remove the <ProjectName>. prefix that Swift adds:
        return classNameComponents.last!
    }
    
    static var moduleName: String? {
        let components = classNameComponents
        return components.count > 1
            ? components.first!
            : nil
    }
    
    static var sizeFromNib: CGSize? {
        return (bundle?
            .loadNibNamed(nibName, owner:nil, options: [:])?
            .first as? UIView)?
            .frame.size
    }
    
    // MARK: - Instance functions
    
    func copyConstraints(from view: UIView) {
        translatesAutoresizingMaskIntoConstraints = view.translatesAutoresizingMaskIntoConstraints
        for constraint in view.constraints {
            if var firstItem = constraint.firstItem as? UIView,
                var secondItem = constraint.secondItem as? UIView
            {
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
            for axis in [UILayoutConstraintAxis.horizontal, UILayoutConstraintAxis.vertical] {
                setContentCompressionResistancePriority(view.contentCompressionResistancePriority(for: axis), for: axis)
                setContentHuggingPriority(view.contentHuggingPriority(for: axis), for: axis)
            }
        }
    }
    
    var viewFromNib: UIView? {
        let nibName = type(of: self).nibName
        guard let nibViews = type(of: self).bundle?.loadNibNamed(nibName, owner: nil, options: nil),
            let nibView = nibViews.first(where: { type(of: $0) == type(of: self) } ) as? UIView
            else {
                debugPrint("**** error: Could not find an instance of class \(type(of: self)) in \(nibName) xib")
                return nil
        }
        (nibView as? Morphable)?.copyProperties(from: self)
        nibView.copyConstraints(from: self)
        return nibView
    }
    
    var copied: UIView {
        let copiedView = type(of: self).init(frame: frame)
        (copiedView as? Morphable)?.copyProperties(from: self)
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
            (copiedSubview as? Morphable)?.copyProperties(from: subview)
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

public extension Morphable where Self: UIView {
    
    func copyProperties(from view: UIView) {
        copyAnimatableProperties(from: view)
        frame = view.frame
        tag = view.tag
        isUserInteractionEnabled = view.isUserInteractionEnabled
        isHidden = view.isHidden
    }
    
}

public extension Morphable where Self: UILabel {
    
    func copyProperties(from view: UIView) {
        (self as UIView).copyConstraints(from: view)
        if let label = view as? UILabel {
            text = label.text
            font = label.font
            textColor = label.textColor
            shadowColor = label.shadowColor
            shadowOffset = label.shadowOffset
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
            tintColor = label.tintColor;
        }
    }
    
}

public extension Morphable where Self: UIImageView {
    
    func copyProperties(from view: UIView) {
        (self as UIView).copyConstraints(from: view)
        if let imageView = view as? UIImageView {
            image = imageView.image
            highlightedImage = imageView.highlightedImage
            isHighlighted = imageView.isHighlighted
            animationImages = imageView.animationImages
        }
    }
    
}
