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
    
    fileprivate var isDynamicLastCell: Bool = false
    fileprivate var needRefreshDynamicLastCellHeight: Bool = true
    fileprivate var dynamicLastCellHeight: CGFloat?
    fileprivate var previousRowFrame = CGRect()
    fileprivate var shouldCallHeightForRow = true
    
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
        var height = self.tableView.estimatedRowHeight
        if let cell = self.tableView.cellForRow(at: self.lastCellIndexPath) {
            // Already on screen or static table view controller.
            cell.layoutIfNeeded()
            height = cell.frame.height
        } else {
            // Hasn't loaded yet in cellForRowAt, calculate height after tableView is fully loaded.
            self.isDynamicLastCell = true
        }
        return height
    }()
    
    fileprivate var secondLastCellIndexPath: IndexPath {
        let indexPath = lastCellIndexPath
        let prevIndexPath: IndexPath
        let seconLastRowIndex = indexPath.row - 1
        if seconLastRowIndex < 0 {
            let section = (0 ..< indexPath.section).reversed().first(where: { tableView(tableView, numberOfRowsInSection: $0) > 0 } ) ?? 0
            let row = max(0, tableView(tableView, numberOfRowsInSection: section) - 1)
            prevIndexPath = IndexPath(row: row, section: section)
        } else {
            prevIndexPath = IndexPath(row: seconLastRowIndex, section: indexPath.section)
        }
        return prevIndexPath
    }
    
    fileprivate var secondLastCellRect: CGRect {
        return lastCellIndexPath == secondLastCellIndexPath
            ? .zero
            : tableView.rectForRow(at: secondLastCellIndexPath)
    }
    
    fileprivate var normalisedTableViewHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return tableView.frame.size.height - tableView.safeAreaInsets.top - tableView.safeAreaInsets.bottom
        } else {
            return tableView.frame.size.height - tableView.contentInset.top
        }
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
    
    private func refreshCellHeights() {
        CATransaction.begin()
        shouldCallHeightForRow = false
        CATransaction.setCompletionBlock {
            self.shouldCallHeightForRow = true
        }
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        CATransaction.commit()
    }
    
    @discardableResult fileprivate func updateFillUsingLastCell() -> Bool {
        var shouldRefreshCellHeights = false
        needRefreshDynamicLastCellHeight = false
        // Use default height when last cell is not on the screen.
        guard tableView.indexPathsForVisibleRows?.contains(lastCellIndexPath) ?? false
            else { return shouldRefreshCellHeights }
        // Set default dynamicLastCellHeight.
        dynamicLastCellHeight = intrinsicHeightCells
            ? UITableViewAutomaticDimension
            : super.tableView(tableView, heightForRowAt: superIndexPath(for: lastCellIndexPath))
        previousRowFrame = secondLastCellRect
        // Get height of empty spaces to fill.
        let availableHeight = normalisedTableViewHeight - previousRowFrame.maxY
        if availableHeight.rounded() >= lastCellIntrinsicHeight {
            dynamicLastCellHeight = availableHeight
            shouldRefreshCellHeights = true
        }
        return shouldRefreshCellHeights
    }
    
    open func refreshDynamicLastCellHeight() {
        needRefreshDynamicLastCellHeight = true
        DispatchQueue.main.async {
            if self.updateFillUsingLastCell() {
                self.refreshCellHeights()
            }
        }
    }
    
    // MARK: - UIViewController
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if intrinsicHeightCells || filledUsingLastCell {
            tableView.estimatedRowHeight = 44.0
        }
        NotificationCenter.default.addObserver(self, selector: #selector(StaticTableViewController.UIApplicationDidChangeStatusBarFrameHandler(for:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarFrame, object: nil)
    }
    
    deinit {
        // Call removeObserver to support iOS 8 or earlier.
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidChangeStatusBarFrame, object: nil)
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if filledUsingLastCell {
            refreshDynamicLastCellHeight()
        } else if intrinsicHeightCells {
            tableView.updateTableViewCellHeights()
        }
    }
    
    @objc internal func UIApplicationDidChangeStatusBarFrameHandler (for notification: Foundation.Notification) {
        if filledUsingLastCell {
            refreshDynamicLastCellHeight()
        }
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
    
    // MARK: - UITableViewDelegate
    open override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if filledUsingLastCell && needRefreshDynamicLastCellHeight {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
                let lastIndexPath = indexPathsForVisibleRows.last,
                lastIndexPath.row == indexPath.row
            {
                // Calculate height of last cell.
                DispatchQueue.main.async {
                    if self.updateFillUsingLastCell() {
                        self.refreshCellHeights()
                    }
                }
            }
        }
    }
    
    open override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return super.tableView(tableView, heightForRowAt: superIndexPath(for: indexPath))
    }
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = intrinsicHeightCells
            ? UITableViewAutomaticDimension
            : super.tableView(tableView, heightForRowAt: superIndexPath(for: indexPath))
        if filledUsingLastCell && indexPath == lastCellIndexPath {
            if isDynamicLastCell {
                if let dynamicLastCellHeight = self.dynamicLastCellHeight {
                    height = dynamicLastCellHeight
                    if shouldCallHeightForRow {
                        let currentPreviousRowFrame = secondLastCellRect
                        // Detect changes on tableView contents after dynamicLastCellHeight is set.
                        if currentPreviousRowFrame.maxY != previousRowFrame.maxY {
                            refreshDynamicLastCellHeight()
                        }
                    }
                }
            } else {
                previousRowFrame = secondLastCellRect
                // Get height of empty spaces to fill.
                let availableHeight = normalisedTableViewHeight - previousRowFrame.maxY
                if availableHeight > lastCellIntrinsicHeight {
                    height = availableHeight
                    dynamicLastCellHeight = height
                }
            }
        }
        return height
    }
}
