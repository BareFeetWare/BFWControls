//
//  DynamicHeightCellViewController.swift
//  BFWControls
//
//  Created by Andy Kim on 10/6/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//

import UIKit
import BFWControls

class DynamicHeightCellViewController: StaticTableViewController {

}

extension DynamicHeightCellViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Refresh table view to calculate height with changes.
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
