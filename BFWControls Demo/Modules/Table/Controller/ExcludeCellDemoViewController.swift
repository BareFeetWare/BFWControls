//
//  ExcludeCellDemoViewController.swift
//  BFWControls
//
//  Created by Andy Kim on 9/6/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//

import UIKit
import BFWControls

class ExcludeCellDemoViewController: StaticTableViewController {

    var selectedCells =  [UITableViewCell]()
    
    override var excludedCells: [UITableViewCell] {
        return selectedCells
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        removeCell(indexPath: indexPath)
    }

    fileprivate func removeCell(indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            selectedCells.append(cell)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func actionShowAll(_ sender: Any) {
        selectedCells = [UITableViewCell]()
        tableView.reloadData()
    }
    
}
