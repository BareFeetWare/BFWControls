//
//  NibContainerButton.swift
//
//  Created by Tom Brodhurst-Hill on 2/03/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibContainerButton: UIButton {

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
        addContentSubview()
        // Allow presses on the content to pass through to the button itself:
        contentSubview.isUserInteractionEnabled = false
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        commonAwake()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonAwake()
    }
    
    open func commonAwake() {
        titleLabel?.text = super.title(for: .normal)
        super.setTitle(nil, for: .normal)
    }
    
    // MARK: - UIButton
    
    open override var titleLabel: UILabel? {
        return (contentSubview as? Interchangeable)?.textLabel
    }
    
}

extension NibContainerButton: NibContainer {
    public var contentView: UIView {
        return self
    }
}
