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
    
    // MARK: - Variables

    @IBInspectable var filledUsingLastCell: Bool = false
    @IBInspectable var intrinsicHeightCells: Bool = false
    
    /// Override in subclass, usually by connecting to an IBOutlet collection.
    var excludedCells: [UITableViewCell]? {
        return nil
    }
    
    // TODO: Move to UITableView?
    var lastCell: UITableViewCell? {
        let lastSection = numberOfSections(in: tableView) - 1
        let lastRow = self.tableView(tableView, numberOfRowsInSection: lastSection) - 1
        let indexPath = IndexPath(row: lastRow, section: lastSection)
        let lastCell = tableView.cellForRow(at: indexPath)
        return lastCell
    }
    
    // MARK: - Functions
    
    func indexPaths(toInsertCells cells: [UITableViewCell]) -> [IndexPath] {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if intrinsicHeightCells {
            tableView.estimatedRowHeight = 44.0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if filledUsingLastCell {
            if let lastCell = lastCell {
                let adjustment = tableView.frame.height + tableView.contentInset.top - lastCell.frame.maxY
                if adjustment > 0 {
                    lastCell.frame.size.height += adjustment
                    lastCell.setNeedsLayout()
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = super.tableView(tableView, numberOfRowsInSection: section)
        let indexPath = IndexPath(row: numberOfRowsInSection - 1, section: section)
        let numberOfExcludedCellsInThisSection = numberOfExcludedRows(before: indexPath)
        return super.tableView(tableView, numberOfRowsInSection: section) - numberOfExcludedCellsInThisSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: superIndexPath(for: indexPath))
        cell.layoutIfNeeded()
        return cell
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = intrinsicHeightCells
            ? UITableViewAutomaticDimension
            : super.tableView(tableView, heightForRowAt: superIndexPath(for: indexPath))
        return height
    }
    
}
