//
//  AdjustingTableViewController.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 7/8/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class AdjustingTableViewController: UITableViewController {
    
    // MARK: - Variables
    
    @IBInspectable open var filledUsingLastCell: Bool = false
    @IBInspectable open var intrinsicHeightCells: Bool = false
    
    private var isDynamicLastCell: Bool = false
    private var needRefreshDynamicLastCellHeight: Bool = true
    private var dynamicLastCellHeight: CGFloat?
    private var previousRowFrame = CGRect()
    private var shouldCallHeightForRow = true
    
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
    
    // MARK: - Private functions
    
    open var secondLastCellIndexPath: IndexPath {
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
    
    private var secondLastCellRect: CGRect {
        return lastCellIndexPath == secondLastCellIndexPath
            ? .zero
            : tableView.rectForRow(at: secondLastCellIndexPath)
    }
    
    private var normalisedTableViewHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return tableView.frame.size.height - tableView.safeAreaInsets.top - tableView.safeAreaInsets.bottom
        } else {
            return tableView.frame.size.height - tableView.contentInset.top
        }
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
            ? UITableView.automaticDimension
            : super.tableView(tableView, heightForRowAt: lastCellIndexPath)
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
        NotificationCenter.default.addObserver(self, selector: #selector(AdjustingTableViewController.UIApplicationDidChangeStatusBarFrameHandler(for:)), name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
    }
    
    deinit {
        // Call removeObserver to support iOS 8 or earlier.
        NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
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
    
    // MARK: - UITableViewDelegate
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = intrinsicHeightCells
            ? UITableView.automaticDimension
            : super.tableView(tableView, heightForRowAt: indexPath)
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
    
}
