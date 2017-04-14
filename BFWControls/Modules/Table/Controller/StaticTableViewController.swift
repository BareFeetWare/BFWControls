//
//  StaticTableViewController.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 29/05/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class StaticTableViewController: UITableViewController {
    
    // MARK: - Variables

    @IBInspectable open var filledUsingLastCell: Bool = false
    @IBInspectable open var intrinsicHeightCells: Bool = false
    
    /// Override in subclass, usually by connecting to an IBOutlet collection.
    open var excludedCells: [UITableViewCell]? {
        return nil
    }
    
    // TODO: Move to UITableView?
    open var lastCellIndexPath: IndexPath {
        let lastSection = numberOfSections(in: tableView) - 1
        let lastRow = self.tableView(tableView, numberOfRowsInSection: lastSection) - 1
        let indexPath = IndexPath(row: lastRow, section: lastSection)
        return indexPath
    }
    
    open lazy var lastCellIntrinsicHeight: CGFloat = {
        let lastCell: UITableViewCell
        if let cell = self.tableView.cellForRow(at: self.lastCellIndexPath) {
            // Already on screen or static table view controller
            lastCell = cell
        } else {
            // Hasn't loaded yet in cellForRowAt, so load a copy
            lastCell = self.tableView(self.tableView, cellForRowAt: self.lastCellIndexPath)
        }
        lastCell.layoutIfNeeded()
        return lastCell.frame.height
    }()
    
    // MARK: - Functions
    
    open func indexPaths(toInsert cells: [UITableViewCell]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for section in 0 ..< super.numberOfSections(in: tableView) {
            var numberOfExcludedRows = 0
            for row in 0 ..< super.tableView(tableView, numberOfRowsInSection: section) {
                let superIndexPath = IndexPath(row: row, section: section)
                let superCell = super.tableView(tableView, cellForRowAt: superIndexPath)
                if cells.contains(superCell) && tableView.indexPath(for: superCell) == nil {
                    let indexPath = IndexPath(row: row - numberOfExcludedRows, section: section)
                    indexPaths += [indexPath]
                } else if excludedCells?.contains(superCell) ?? false {
                    numberOfExcludedRows += 1
                }
            }
        }
        return indexPaths
    }
    
    // MARK: - Private functions
    
    fileprivate func numberOfExcludedRows(before indexPath: IndexPath) -> Int {
        var numberOfExcludedRows = 0
        if let excludedCells = excludedCells {
            let superSection = (indexPath as NSIndexPath).section
            for superRow in 0 ..< super.tableView(tableView, numberOfRowsInSection: superSection) {
                let superIndexPath = IndexPath(row: superRow, section: superSection)
                let cell = super.tableView(tableView, cellForRowAt: superIndexPath)
                if excludedCells.contains(cell) {
                    numberOfExcludedRows += 1
                } else if superRow - numberOfExcludedRows == (indexPath as NSIndexPath).row {
                    break
                }
            }
        }
        return numberOfExcludedRows
    }
    
    fileprivate func superIndexPath(for indexPath: IndexPath) -> IndexPath {
        return IndexPath(row: (indexPath as NSIndexPath).row + numberOfExcludedRows(before: indexPath),
                         section: (indexPath as NSIndexPath).section)
    }
    
    // MARK: - UIViewController
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if intrinsicHeightCells || filledUsingLastCell {
            tableView.estimatedRowHeight = 44.0
        }
    }
    
    // MARK: - UITableViewDataSource
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = super.tableView(tableView, numberOfRowsInSection: section)
        let indexPath = IndexPath(row: numberOfRowsInSection - 1, section: section)
        let numberOfExcludedCellsInThisSection = numberOfExcludedRows(before: indexPath)
        return super.tableView(tableView, numberOfRowsInSection: section) - numberOfExcludedCellsInThisSection
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: superIndexPath(for: indexPath))
        cell.layoutIfNeeded()
        return cell
    }
    
    // MARK: - UITableViewDelegate

    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = intrinsicHeightCells
            ? UITableViewAutomaticDimension
            : super.tableView(tableView, heightForRowAt: superIndexPath(for: indexPath))
        if filledUsingLastCell && indexPath == lastCellIndexPath {
            let previousRowFrame = tableView.rectForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section))
            // Get height of empty spaces to fill
            let availableHeight = tableView.frame.size.height - previousRowFrame.maxY
            if availableHeight > lastCellIntrinsicHeight {
                height = availableHeight
            }
        }
        return height
    }
    
}
