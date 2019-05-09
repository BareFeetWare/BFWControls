//
//  NibTableViewHeaderFooterView.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 26/3/17.
//  Copyright © 2017 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibTableViewHeaderFooterView: BFWNibTableViewHeaderFooterView, NibReplaceable {
    
    // MARK: - NibReplaceable
    
    open var nibName: String?
    
    open var placeholderViews: [UIView] {
        return [textLabel].compactMap { $0 }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet open override var textLabel: UILabel? {
        get {
            return overridingTextLabel
        }
        set {
            overridingTextLabel = newValue
        }
    }
    
    // MARK: - Private variables
    
    private var overridingTextLabel: UILabel?
    
    // MARK: - Init
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    /// Convenience called by init(frame:) and init(coder:). Override in subclasses if required.
    open func commonInit() {
    }
    
    open override func awakeAfter(using coder: NSCoder) -> Any? {
        guard let nibView = replacedByNibView()
            else { return self }
        nibView.removePlaceholders()
        return nibView
    }
    
    // MARK: - UITableViewHeaderFooterView
    
    open override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            // Prevent constraint error, which seems to be an Apple bug.
            // See: https://stackoverflow.com/questions/17581550/uitableviewheaderfooterview-subclass-with-auto-layout-and-section-reloading-won
            guard newValue.size.width != 0.0 else { return }
            super.frame = newValue
        }
    }
    
}

@objc public extension NibTableViewHeaderFooterView {
    
    @objc func replacedByNibViewForInit() -> Self? {
        return replacedByNibView()
    }
    
}
