//
//  NibContainerButton.swift
//
//  Created by Tom Brodhurst-Hill on 2/03/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

@available(*, deprecated, message: "Use NibButton instead.")
open class NibContainerButton: UIButton {
    
    // MARK: - NibView container
    
    private func addContentSubview() {
        addSubview(nibView)
        nibView.pinToSuperviewEdges()
        // Allow presses on the content to pass through to the button itself:
        nibView.isUserInteractionEnabled = false
    }
    
    open var nibView: NibView {
        fatalError("Concrete subclass must provide nibView.")
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
        addContentSubview()
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
        return (nibView as? TextLabelProvider)?.textLabel
    }
    
}
