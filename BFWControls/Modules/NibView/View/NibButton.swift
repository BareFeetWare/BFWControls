//
//  NibButton.swift
//
//  Created by Tom Brodhurst-Hill on 2/03/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

open class NibButton: UIButton {
    
    // MARK: - Variables
    
    /// Override in subclass
    open var contentView: NibView? {
        return nil
    }
    
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
        if let contentView = contentView {
            addSubview(contentView)
            contentView.pinToSuperviewEdges()
            contentView.isUserInteractionEnabled = false
        }
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
        titleLabel?.text = title(for: .normal)
        setTitle(nil, for: .normal)
    }
    
}
