//
//  UIView+Copy.swift
//
//  Created by Tom Brodhurst-Hill on 6/11/2015.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

extension UIView {
    
    // MARK - Class methods
    
    fileprivate static var bundle: Bundle {
        let isInterfaceBuilder: Bool
        #if TARGET_INTERFACE_BUILDER // Rendering in storyboard using IBDesignable.
            isInterfaceBuilder = true
        #else
            isInterfaceBuilder = false
        #endif
        let bundle: Bundle = isInterfaceBuilder
            ? Bundle(for: self)
                // TODO: Dynamic strings:
            : moduleName == "BFWControls"
            ? Bundle(identifier: "com.barefeetware.BFWControls")!
            : Bundle.main
        return bundle
    }
    
    fileprivate static var classNameComponents: [String] {
        let fullClassName = NSStringFromClass(self)
        return fullClassName.components(separatedBy: ".")
    }
    
    fileprivate static var nibName: String {
        // Remove the <ProjectName>. prefix that Swift adds:
        return classNameComponents.last!
    }
    
    fileprivate static var moduleName: String? {
        let components = classNameComponents
        return components.count > 1
            ? components.first
            : nil
    }
    
    internal static var sizeFromNib: CGSize {
        guard let nibViews = bundle.loadNibNamed(nibName, owner: nil),
            let nibView = nibViews.first(where: { $0 is UIView } ) as? UIView
            else { return .zero }
        let size = nibView.frame.size
        return size
    }
    
    // MARK: - Instance variables and functions
    
    func copyConstraints(from view: UIView) {
        translatesAutoresizingMaskIntoConstraints = view.translatesAutoresizingMaskIntoConstraints
        for constraint in view.constraints {
            var firstItem = constraint.firstItem as! NSObject
            var secondItem = constraint.secondItem as? NSObject
            if firstItem == view {
                firstItem = self
            }
            if secondItem == view {
                secondItem = self
            }
            let copiedConstraint = NSLayoutConstraint(item: firstItem,
                                                      attribute: constraint.firstAttribute,
                                                      relatedBy: constraint.relation,
                                                      toItem: secondItem,
                                                      attribute: constraint.secondAttribute,
                                                      multiplier: constraint.multiplier,
                                                      constant: constraint.constant)
            addConstraint(copiedConstraint)
        }
        for axis: UILayoutConstraintAxis in [.horizontal, .vertical] {
            setContentCompressionResistancePriority(view.contentCompressionResistancePriority(for: axis), for: axis)
            setContentHuggingPriority(view.contentHuggingPriority(for: axis), for: axis)
        }
    }
    
    public var viewFromNib: UIView? {
        let nibName = type(of: self).nibName
        let nibViews = type(of: self).bundle.loadNibNamed(nibName, owner: nil, options: nil)?.filter { $0 is UIView } as? [UIView]
        guard let nibView = nibViews?.first(where: { type(of: $0) == type(of: self) })
            else {
                debugPrint( "**** error: Could not find an instance of class \(NSStringFromClass(type(of: self))) in \(nibName) xib")
                return nil
        }
        nibView.copyProperties(from: self)
        nibView.copyConstraints(from: self)
        return nibView
    }
    
    fileprivate var copied: UIView {
        let copiedView = type(of: self).init(frame: frame)
        copiedView.copyProperties(from: self)
        return copiedView
    }
    
    internal func copyWithSubviews(_ subviews: [UIView],
                                   includeConstraints: Bool)
        -> UIView
    {
        let copiedView = copied
        copiedView.copySubviews(subviews,
                                includeConstraints:includeConstraints)
        return copiedView
    }
    
    func copySubviews(_ subviews: [UIView],
                      includeConstraints: Bool )
    {
        for subview in subviews {
            let copiedSubview = type(of: subview).init(frame: subview.frame)
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
        if let copiedBackgroundColor = view.backgroundColor {
            backgroundColor = copiedBackgroundColor
        }
        transform = view.transform
    }
    
}

// TODO: Move to separte file(s):

protocol PropertiesCopyable {
    
    func copyProperties(from view: UIView)
    
}

extension UIView: PropertiesCopyable {
    
    func copyProperties(from view: UIView) {
        copyAnimatableProperties(from: view)
        frame = view.frame
        tag = view.tag
        isUserInteractionEnabled = view.isUserInteractionEnabled
        isHidden = view.isHidden
    }
    
}

extension UILabel {
    
    override func copyProperties(from view: UIView) {
        super.copyProperties(from: view)
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
            tintColor = label.tintColor
        }
    }
    
}

extension UIImageView {
    
    override func copyProperties(from view: UIView) {
        super.copyProperties(from: view)
        if let imageView = view as? UIImageView {
            image = imageView.image
            highlightedImage = imageView.highlightedImage
            isHighlighted = imageView.isHighlighted
            animationImages = imageView.animationImages
        }
    }
    
}
