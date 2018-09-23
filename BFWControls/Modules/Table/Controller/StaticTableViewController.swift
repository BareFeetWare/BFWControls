//
//  StaticTableViewController.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 29/05/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class StaticTableViewController: AdjustingTableViewController {
    
    /// Override in subclass, usually by connecting to an IBOutlet collection.
    open var excludedCells: [UITableViewCell]? {
        return nil
    }
    
    // MARK: - Functions
    
    open func indexPaths(toInsert cells: [UITableViewCell]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for section in 0 ..< super.numberOfSections(in: tableView) {
            var numberOfExcludedRows = 0
            for row in 0 ..< super.tableView(tableView, numberOfRowsInSection: superSection(forSection: section)) {
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
    
    private func numberOfExcludedSections(beforeSection section: Int) -> Int {
        var numberOfExcludedSections = 0
        for superSection in 0 ..< super.numberOfSections(in: tableView) {
            if !shouldInclude(superSection: superSection) {
                numberOfExcludedSections += 1
            } else if superSection - numberOfExcludedSections == section {
                break
            }
        }
        return numberOfExcludedSections
    }
    
    private func numberOfExcludedRowsInSuperSection(before superIndexPath: IndexPath) -> Int {
        var numberOfExcludedRows = 0
        if let excludedCells = excludedCells, !excludedCells.isEmpty {
            for superRow in 0 ..< super.tableView(tableView, numberOfRowsInSection: superIndexPath.section) {
                let steppedSuperIndexPath = IndexPath(row: superRow, section: superIndexPath.section)
                let cell = super.tableView(tableView, cellForRowAt: steppedSuperIndexPath)
                if excludedCells.contains(cell) {
                    numberOfExcludedRows += 1
                } else if superRow - numberOfExcludedRows == superIndexPath.row {
                    break
                }
            }
        }
        return numberOfExcludedRows
    }
    
    private func numberOfExcludedRows(inSuperSection superSection: Int) -> Int {
        let numberOfRows = super.tableView(tableView, numberOfRowsInSection: superSection)
        let indexPath = IndexPath(row: numberOfRows - 1, section: superSection)
        return numberOfExcludedRowsInSuperSection(before: indexPath)
    }
    
    private func shouldInclude(superSection: Int) -> Bool {
        guard let excludedCells = excludedCells, !excludedCells.isEmpty
            else { return true }
        let rows = 0 ..< super.tableView(tableView, numberOfRowsInSection: superSection)
        let firstIncludedRow = rows.first { row in
            let indexPath = IndexPath(row: row, section: superSection)
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            return !excludedCells.contains(cell)
        }
        return firstIncludedRow != nil
    }
    
    private func superSection(forSection section: Int) -> Int {
        guard let excludedCells = excludedCells, !excludedCells.isEmpty
            else { return section }
        return section + numberOfExcludedSections(beforeSection: section)
    }
    
    private func superIndexPath(for indexPath: IndexPath) -> IndexPath {
        guard let excludedCells = excludedCells, !excludedCells.isEmpty
            else { return indexPath }
        let superSection = self.superSection(forSection: indexPath.section)
        let indexPathInSuperSection = IndexPath(row: indexPath.row, section: superSection)
        let superIndexPath = IndexPath(row: indexPath.row + numberOfExcludedRowsInSuperSection(before: indexPathInSuperSection),
                                       section: superSection)
        return superIndexPath
    }
    
    // MARK: - UITableViewDataSource
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        let superNumberOfSections = super.numberOfSections(in: tableView)
        guard let excludedCells = excludedCells, !excludedCells.isEmpty
            else { return superNumberOfSections }
        var numberOfSections = 0
        for superSection in 0 ..< superNumberOfSections {
            if shouldInclude(superSection: superSection) {
                numberOfSections += 1
            }
        }
        return numberOfSections
    }
    
    open override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return super.tableView(tableView, heightForHeaderInSection: superSection(forSection: section))
    }
    
    open override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return super.tableView(tableView, heightForFooterInSection: superSection(forSection: section))
    }
    
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return super.tableView(tableView, titleForHeaderInSection: superSection(forSection: section))
    }
    
    open override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return super.tableView(tableView, titleForFooterInSection: superSection(forSection: section))
    }
    
    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return super.tableView(tableView, viewForHeaderInSection: superSection(forSection: section))
    }
    
    open override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return super.tableView(tableView, viewForFooterInSection: superSection(forSection: section))
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let excludedCells = excludedCells, !excludedCells.isEmpty
            else { return super.tableView(tableView, numberOfRowsInSection: section) }
        let superSection = self.superSection(forSection: section)
        let numberOfRowsInSuperSection = super.tableView(tableView, numberOfRowsInSection: superSection)
        let numberOfExcludedRowsInThisSection: Int = numberOfRowsInSuperSection == 0
            ? 0
            : numberOfExcludedRows(inSuperSection: superSection)
        return numberOfRowsInSuperSection - numberOfExcludedRowsInThisSection
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: superIndexPath(for: indexPath))
        cell.layoutIfNeeded()
        return cell
    }
    
}
