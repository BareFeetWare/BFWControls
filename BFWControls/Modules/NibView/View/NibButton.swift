//
//  NibButton.swift
//
//  Created by Tom Brodhurst-Hill on 2/03/2016.
//  Copyright © 2016 BareFeetWare. All rights reserved.
//

import UIKit

class NibButton: UIButton {
    
    // MARK: - Variables
    
    /// Override in subclass
    var contentView: BFWNibView? {
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
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.userInteractionEnabled = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonAwake()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonAwake()
    }
    
    func commonAwake() {
        titleLabel?.text = titleForState(.Normal)
        setTitle(nil, forState: .Normal)
    }
    
}
