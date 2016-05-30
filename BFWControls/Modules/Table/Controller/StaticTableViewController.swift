//
//  StaticTableViewController.swift
//  Spring
//
//  Created by Tom Brodhurst-Hill on 29/05/2016.
//  Copyright © 2016 Optus. All rights reserved.
//

import UIKit

class StaticTableViewController: UITableViewController {
    
    /// Override in subclass, usually by connecting to an IBOutlet collection.
    var excludedCells: [UITableViewCell]? {
        return nil
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = super.tableView(tableView, numberOfRowsInSection: section)
        let indexPath = NSIndexPath(forRow: numberOfRowsInSection - 1, inSection: section)
        let numberOfExcludedCellsInThisSection = numberOfExcludedRowsBeforeIndexPath(indexPath)
        return super.tableView(tableView, numberOfRowsInSection: section) - numberOfExcludedCellsInThisSection
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return super.tableView(tableView, cellForRowAtIndexPath: superIndexPathForIndexPath(indexPath))
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return super.tableView(tableView, heightForRowAtIndexPath: superIndexPathForIndexPath(indexPath))
    }
    
    // MARK: - Private functions
    
    private func numberOfExcludedRowsBeforeIndexPath(indexPath: NSIndexPath) -> Int {
        var numberOfExcludedRows = 0
        if let excludedCells = excludedCells {
            let superSection = indexPath.section
            for superRow in 0 ..< super.tableView(tableView, numberOfRowsInSection: superSection) {
                let superIndexPath = NSIndexPath(forRow: superRow, inSection: superSection)
                let cell = super.tableView(tableView, cellForRowAtIndexPath: superIndexPath)
                if excludedCells.contains(cell) {
                    numberOfExcludedRows += 1
                } else if superRow - numberOfExcludedRows == indexPath.row {
                    break
                }
            }
        }
        return numberOfExcludedRows
    }
    
    private func superIndexPathForIndexPath(indexPath: NSIndexPath) -> NSIndexPath {
        return NSIndexPath(forRow: indexPath.row + numberOfExcludedRowsBeforeIndexPath(indexPath),
                           inSection: indexPath.section)
    }
    
}
