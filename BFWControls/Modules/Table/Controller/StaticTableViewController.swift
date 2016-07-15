//
//  StaticTableViewController.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 29/05/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

class StaticTableViewController: UITableViewController {
    
    @IBInspectable var fillUsingLastCell: Bool = false
    
    /// Override in subclass, usually by connecting to an IBOutlet collection.
    var excludedCells: [UITableViewCell]? {
        return nil
    }
    
    // MARK: - Functions
    
    func indexPathsToInsertCells(cells: [UITableViewCell]) -> [NSIndexPath] {
        var indexPaths = [NSIndexPath]()
        for section in 0 ..< super.numberOfSectionsInTableView(tableView) {
            var numberOfExcludedRows = 0
            for row in 0 ..< super.tableView(tableView, numberOfRowsInSection: section) {
                let superIndexPath = NSIndexPath(forRow: row, inSection: section)
                let superCell = super.tableView(tableView, cellForRowAtIndexPath: superIndexPath)
                if cells.contains(superCell) && tableView.indexPathForCell(superCell) == nil {
                    let indexPath = NSIndexPath(forRow: row - numberOfExcludedRows, inSection: section)
                    indexPaths += [indexPath]
                } else if excludedCells?.contains(superCell) ?? false {
                    numberOfExcludedRows += 1
                }
            }
        }
        return indexPaths
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
    
    private func updateCellHeights() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK: - UIViewController
    
    // TODO: Implement with new callback methods.
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        updateCellHeights()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = super.tableView(tableView, numberOfRowsInSection: section)
        let indexPath = NSIndexPath(forRow: numberOfRowsInSection - 1, inSection: section)
        let numberOfExcludedCellsInThisSection = numberOfExcludedRowsBeforeIndexPath(indexPath)
        return super.tableView(tableView, numberOfRowsInSection: section) - numberOfExcludedCellsInThisSection
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: superIndexPathForIndexPath(indexPath))
        cell.layoutIfNeeded()
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = super.tableView(tableView, heightForRowAtIndexPath: superIndexPathForIndexPath(indexPath))
        if fillUsingLastCell
            && numberOfSectionsInTableView(tableView) == 1
            && indexPath.row == self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1
        {
            var cellTop = tableView.contentInset.top
            for row in 0 ..< indexPath.row {
                let beforeIndexPath = NSIndexPath(forRow: row, inSection: indexPath.section)
                cellTop += self.tableView(tableView, heightForRowAtIndexPath: beforeIndexPath)
            }
            let maxHeight = tableView.frame.size.height - cellTop
            if height < maxHeight {
                height = maxHeight
            }
        }
        return height
    }
    
}
