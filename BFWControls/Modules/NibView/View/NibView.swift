//
//  NibView.swift
//
//  Created by Tom Brodhurst-Hill on 27/03/2016.
//  Copyright © 2016 BareFeetWare. Free to use and modify, without warranty.
//

import UIKit

class NibView: BFWNibView {

    // MARK: - Variables
    
    /// Labels which should remove enclosing [] from text after awakeFromNib.
    var placeholderLabels: [UILabel]? {
        return nil
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
        removePlaceHolderText()
    }

    // MARK: - Private variables and functions.
    
    /// Replace placeholders (eg [Text]) with blank text.
    private func removePlaceHolderText() {
        if let labels = placeholderLabels {
            for label in labels {
                label.removePlaceholderText()
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

private extension UILabel {
    
    func removePlaceholderText() {
        if let text = text where text.hasPrefix("[") && text.hasSuffix("]") {
            self.text = nil
        }
    }
    
}
