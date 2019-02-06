//
//  UIStackView+Joined.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 22/7/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use and modify, without warranty.
//

import UIKit

@available(iOS 9.0, *)
public extension UIStackView {
    
    /// Returns a string containing the stack view's labels' text, using the specified separators.
    func textJoinedFromSubviews(columnSeparator: String = ":",
                                rowSeparator: String = ",") -> String?
    {
        return subviews
            .map {
                ($0.subviews as! [UILabel])
                    .map { $0.text }
                    .compactMap { $0 }
                    .joined(separator: columnSeparator)
            }
            .joined(separator: rowSeparator)
    }
    
    /// Updates the stack view's subviews so each label contains a component when the string is separated using the specified separators.
    func updateSubviews(fromString string: String,
                        columnSeparator: String = ":",
                        rowSeparator: String = ",")
    {
        let rowStrings = string.components(separatedBy: rowSeparator)
        let oldRowCount = subviews.count
        let addingRowCount = rowStrings.count - oldRowCount
        if addingRowCount < 0 {
            subviews.dropFirst(-addingRowCount)
                .forEach {
                    removeArrangedSubview($0)
                    $0.removeFromSuperview()
            }
        } else if addingRowCount > 0 {
            for _ in 1 ... addingRowCount {
                let sourceView = subviews.first!
                let duplicatedRowView = sourceView.copied(withSubviews: sourceView.subviews,
                                                          includeConstraints: false)
                if let stackRowView = duplicatedRowView as? UIStackView {
                    stackRowView.subviews.forEach { stackRowView.addArrangedSubview($0) }
                }
                addArrangedSubview(duplicatedRowView)
            }
        }
        for (index, rowString) in rowStrings.enumerated() {
            let labels = arrangedSubviews[index].subviews as! [UILabel]
            let strings = rowString.components(separatedBy: columnSeparator)
            labels.first!.text = strings.first!
            labels[1].text = strings.dropFirst().joined(separator: columnSeparator)
        }
    }
    
}
