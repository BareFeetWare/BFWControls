//
//  DynamicCellDemoViewController.swift
//  BFWControls
//
//  Created by Andy Kim on 9/6/17.
//  Copyright © 2017 BareFeetWare. All rights reserved.
//

import UIKit
import BFWControls

class DynamicCellDemoViewController: StaticTableViewController {

    // MARK: - Variables
    fileprivate var rowCount = 0

    // MARK: - Private functions
    fileprivate func insertRow() {
        rowCount += 1
        tableView.insertRows(at: [IndexPath(row: rowCount - 1, section: 0)], with: .right)
        reloadAllVisibleRows()
    }
    
    fileprivate func deleteRow(at indexPath: IndexPath) {
        rowCount -= 1
        tableView.deleteRows(at: [indexPath], with: .left)
        reloadAllVisibleRows()
    }
    
    fileprivate func reloadAllVisibleRows() {
        if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: indexPathsForVisibleRows, with: .automatic)
        }
    }
    
    // MARK: - Actions
    @IBAction func actionAddCell(_ sender: Any) {
        insertRow()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dynamic", for: indexPath)
        cell.textLabel?.text = "rowIndex: \(indexPath.row)"
        return cell
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deleteRow(at: indexPath)
    }
    
}

