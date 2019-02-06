//
//  NibReplaceable.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 4/5/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//

/*
// Implement in conforming class:

// For runtime:
 
open override func awakeAfter(using coder: NSCoder) -> Any? {
    guard let nibView = replacedByNibView()
        else { return self }
    nibView.removePlaceholders()
    return nibView
}

// For Interface Builder, IBDesignable:

@objc public extension NibView {
    
    @objc func replacedByNibViewForInit() -> Self? {
        return replacedByNibView()
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return [(NibView *)self replacedByNibViewForInit];
}
*/

// Storage required since a protocol extension can not store variables.
fileprivate class Storage {
    
    /// Prevents recursive call by loadNibNamed to itself. Safe as a static var since it is always called on the main thread, ie synchronously.
    static var loadingStack: [AnyClass] = []
    static var sizeForKeyDictionary = [String: CGSize]()

}

public protocol NibReplaceable where Self: UIView {
    
    /// Override to give different nib for each cell style
    var nibName: String? { get }
    
    /// Labels and buttons which should remove enclosing [] from text at runtime, if not replaced with another value.
    var placeholderViews: [UIView] { get }
    
}

public extension NibReplaceable {
    
    // MARK: - Protocol variable defaults that can be overridden
    
    /// Override to give different nib for each cell style or for a particular instance
    var nibName: String? {
        return nil
    }
    
    var placeholderViews: [UIView] {
        return []
    }
    
    // MARK: - Static variables
    
    static var isLoadingFromNib: Bool {
        get {
            return Storage.loadingStack.last == self
        }
        set {
            // TODO: Move stack logic to a type, eg UniqueStack.
            if newValue {
                guard !Storage.loadingStack.contains(where: { $0 == self })
                    else {
                        fatalError("loadingStack tried to append \(self) but laodingStack already contains \(self)")
                }
                Storage.loadingStack.append(self)
            } else {
                guard Storage.loadingStack.last == self
                    else {
                        fatalError("loadingStack tried to remove \(self) but last item is \(Storage.loadingStack.last.map { String(describing: $0) } ?? "nil" )")
                }
                Storage.loadingStack.removeLast()
            }
        }
    }
    
    static var bundle: Bundle? {
        return Bundle(for: self)
    }
    
    static var classNameComponents: [String] {
        let fullClassName = NSStringFromClass(self) // Note: String(describing: self) does not include the moduleName prefix.
        return fullClassName.components(separatedBy: ".")
    }
    
    static var moduleName: String? {
        let components = classNameComponents
        return components.count > 1
            ? components.first!
            : nil
    }
    
    static var nibName: String {
        // Remove the <ProjectName>. prefix that Swift adds:
        return classNameComponents.last!
    }
    
    static var sizeFromNib: CGSize? {
        let size: CGSize?
        let key = NSStringFromClass(self)
        if let reuseSize = Storage.sizeForKeyDictionary[key] {
            size = reuseSize
        } else {
            size = nibView()?.frame.size
            Storage.sizeForKeyDictionary[key] = size
        }
        return size
    }
    
    // MARK: - Static functions
    
    static func nibView(fromNibNamed nibName: String? = nil, in bundle: Bundle? = nil) -> Self? {
        guard !isLoadingFromNib
            else { return nil }
        isLoadingFromNib = true
        defer {
            isLoadingFromNib = false
        }
        let bundle = bundle ?? self.bundle!
        let nibName = nibName ?? self.nibName
        guard let nibViews = bundle.loadNibNamed(nibName, owner: nil, options: nil),
            let nibView = nibViews.first(where: { type(of: $0) == self } ) as? Self
            else {
                fatalError("\(#function) Could not find an instance of class \(self) in \(nibName) xib")
        }
        return nibView
    }
    
    // MARK: - Instance functions
    
    func replacedByNibView(fromNibNamed nibName: String? = nil, in bundle: Bundle? = nil) -> Self? {
        let nibView = type(of: self).nibView(fromNibNamed: nibName, in: bundle)
        nibView?.copyProperties(from: self)
        nibView?.copyConstraints(from: self)
        return nibView
    }
    
    func isPlaceholderString(_ string: String?) -> Bool {
        return string != nil && string!.isPlaceholder
    }
    
    /// Replace placeholders (eg [Text]) with blank text.
    internal func removePlaceholders() {
        for view in placeholderViews {
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

private extension String {
    
    var isPlaceholder: Bool {
        return hasPrefix("[") && hasSuffix("]")
    }
    
}
