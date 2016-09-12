//
//  NibView.swift
//
//  Created by Tom Brodhurst-Hill on 27/03/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

@IBDesignable class NibView: BFWNibView {

    // MARK: - Variables & Functions
    
    /// Labels which should remove enclosing [] from text after awakeFromNib.
    var placeholderViews: [UIView]? {
        return nil
    }

    func isPlaceholderString(string: String?) -> Bool {
        return string != nil && string!.isPlaceholder
    }
    
    // MARK: - UpdateView mechanism
    
    /// Override in subclasses and call super. Update view and subview properties that are affected by properties of this class.
    func updateView() {
    }
    
    func setNeedsUpdateView() {
        needsUpdateView = true
        setNeedsLayout()
    }
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        removePlaceHolders()
    }

    // MARK: - Private variables and functions.
    
    /// Replace placeholders (eg [Text]) with blank text.
    private func removePlaceHolders() {
        if let views = placeholderViews {
            for view in views {
                if let label = view as? UILabel,
                    let text = label.text
                    where text.isPlaceholder
                {
                    label.text = nil
                } else if let button = view as? UIButton {
                    if button.titleForState(.Normal)?.isPlaceholder ?? false {
                        button.setTitle(nil, forState: .Normal)
                    }
                }
            }
        }
    }

    private var needsUpdateView = true
        
    private func updateViewIfNeeded() {
        if needsUpdateView {
            needsUpdateView = false
            updateView()
        }
    }
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        updateViewIfNeeded()
        super.layoutSubviews()
    }

}

private extension String {
    
    var isPlaceholder: Bool {
        return hasPrefix("[") && hasSuffix("]")
    }
    
}
