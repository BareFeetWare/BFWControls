//
//  DemoTableView.swift
//  BFWControls Demo
//
//  Created by Tom Brodhurst-Hill on 30/4/19.
//  Copyright © 2019 BareFeetWare. All rights reserved.
//

import UIKit

@IBDesignable class DemoTableView: UITableView {
    
    override func dequeueReusableHeaderFooterView(withIdentifier identifier: String) -> UITableViewHeaderFooterView? {
        return super.dequeueReusableHeaderFooterView(withIdentifier: identifier) ?? DemoTableViewHeaderFooterView()
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        guard let sectionHeaderHeight = DemoTableViewHeaderFooterView.sizeFromNib?.height
            else { return }
        self.sectionHeaderHeight = sectionHeaderHeight
    }
    
}
