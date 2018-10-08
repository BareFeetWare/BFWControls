//
//  CarouselViewController.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 16/03/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

open class CarouselViewController: UICollectionViewController {
    
    // MARK: - Variables
    
    @IBInspectable open var maxCellWidth: CGFloat = .notSet
    @IBInspectable open var peakCellWidth: CGFloat = .notSet
    @IBInspectable open var advanceInterval: Double = .notSet {
        didSet {
            updateTimer()
        }
    }
    
    private func updateTimer() {
        timer?.invalidate()
        timer = nil
        if advanceInterval != .notSet {
            timer = Timer.scheduledTimer(
                timeInterval: advanceInterval,
                target: self,
                selector: #selector(advancePage(sender:)),
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    @objc private func advancePage(sender: Any?) {
        scroll(toPage: currentPage + 1, animated: true)
    }
    
    private var timer: Timer?
    
    @IBInspectable open var isPageControlHidden: Bool = false {
        didSet {
            updatePageControl()
        }
    }
    
    private func updatePageControl() {
        pageControl.isHidden = isPageControlHidden
    }
    
    @IBInspectable open var controlInsetBottom: CGFloat = 0.0
    
    /// Looped from last back to first page.
    @IBInspectable open var looped: Bool = false
    
    @IBInspectable open var shouldBounce: Bool = false
    
    // MARK: - Static content
    
    /// Cell identifiers for finite static content.
    @IBInspectable open var cell0Identifier: String?
    @IBInspectable open var cell1Identifier: String?
    @IBInspectable open var cell2Identifier: String?
    @IBInspectable open var cell3Identifier: String?
    @IBInspectable open var cell4Identifier: String?
    @IBInspectable open var cell5Identifier: String?
    @IBInspectable open var cell6Identifier: String?
    @IBInspectable open var cell7Identifier: String?
    
    /// Name of plist file containing cell identifiers for long static content.
    @IBInspectable open var dataSourcePlistName: String?
    
    /// Override in subclass for dynamic content or use default implementation for static content.
    open var cellIdentifiers: [String]? {
        return plistDict?[Key.cellIdentifiers.rawValue] as? [String] ?? ibCellIdentifiers
    }
    
    fileprivate enum Key: String {
        case cellIdentifiers
    }
    
    fileprivate var ibCellIdentifiers: [String] {
        return [cell0Identifier,
                cell1Identifier,
                cell2Identifier,
                cell3Identifier,
                cell4Identifier,
                cell5Identifier,
                cell6Identifier,
                cell7Identifier
            ].compactMap { $0 }
    }
    
    fileprivate var plistDict: [String: AnyObject]? {
        guard let dataSourcePlistName = dataSourcePlistName,
            let filePath = Bundle.main.path(forResource: dataSourcePlistName, ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: filePath) as? [String: AnyObject]
            else { return nil }
        return dictionary
    }
    
    // MARK: - Override in subclass for dynamic content
    
    /// Override in subclass for dynamic content or use default implementation for static content.
    open var pageCount: Int {
        return cellIdentifiers?.count ?? 0
    }
    
    /// Override in subclass for dynamic content or use default implementation for static content.
    open override func collectionView(_ collectionView: UICollectionView,
                                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let page = self.page(for: indexPath)
        let cellIdentifier = cellIdentifiers![page]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
    
    // MARK: - Variables
    
    open var currentPage: Int {
        return loopedPage(forPage: Int(round(currentPageFloat)))
    }
    
    open var currentPageFloat: CGFloat {
        let page = currentCellItem - (shouldLoop ? 1 : 0)
        return page < 0 || pageCount == 0
            ? CGFloat(pageCount) + page
            : page.truncatingRemainder(dividingBy: CGFloat(pageCount))
    }
    
    open lazy var pageControl: UIPageControl = {
        /* If this carousel is embedded as a container in another view controller, find a page control already
         existing in that view controller, otherwise create a new one.
         */
        let pageControl = self.view.superview?.superview?.subviews.first { subview in
            subview is UIPageControl
            } as? UIPageControl ?? UIPageControl()
        pageControl.numberOfPages = self.pageCount
        pageControl.sizeToFit()
        return pageControl
    }()
    
    // MARK: - Private variables
    
    fileprivate var collectionViewSize: CGSize?
    
    fileprivate var shouldLoop: Bool {
        return looped && pageCount > 1
    }
    
    fileprivate var currentCellItem: CGFloat {
        return collectionViewSize.map { size in collectionView!.contentOffset.x / maxCellWidth } ?? 0
    }
    
    fileprivate var bounceContentOffsetX: CGFloat = 100
    
    // MARK: - Actions
    
    fileprivate func addPageControl() {
        if pageControl.superview == nil {
            collectionView?.addSubview(pageControl)
            pageControl.sizeToFit()
        }
        pageControl.addTarget(self,
                              action: #selector(changed(pageControl:)),
                              for: .valueChanged)
        pageControl.numberOfPages = pageCount
        pageControl.isHidden = shouldBounce
    }
    
    @IBAction open func changed(pageControl: UIPageControl) {
        scroll(toPage: pageControl.currentPage, animated: true)
    }
    
    fileprivate func updatePageControl(shouldUpdateCurrentPage: Bool = true) {
        if let collectionViewSize = collectionViewSize {
            if pageControl.superview == collectionView {
                pageControl.frame.origin.x = (collectionViewSize.width - pageControl.frame.width) / 2 + collectionView!.contentOffset.x
                pageControl.frame.origin.y = collectionViewSize.height - pageControl.frame.height + collectionView!.contentOffset.y - controlInsetBottom
            }
            pageControl.numberOfPages = pageCount
            if shouldUpdateCurrentPage {
                pageControl.currentPage = currentPage
            }
        }
    }
    
    fileprivate func showBounce() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.collectionView?.setContentOffset(CGPoint(x: self.bounceContentOffsetX, y: 0), animated: false)
        }) {_ in
            self.scroll(toPage: self.pageControl.currentPage, animated: true)
            self.isPageControlHidden = false
        }
        shouldBounce = false
    }
    
    open func scroll(toPage page: Int, animated: Bool) {
        guard pageCount > 0
            else { return }
        let loopedPage = self.loopedPage(forPage: page)
        let scrolledPage = loopedPage + (shouldLoop ? 1 : 0)
        let indexPath = IndexPath(item: scrolledPage, section: 0)
        if shouldLoop && loopedPage == 0 && currentPage == pageCount - 1 {
            collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0),
                                         at: .centeredHorizontally,
                                         animated: false)
        }
        collectionView?.scrollToItem(at: indexPath,
                                     at: .centeredHorizontally,
                                     animated: animated)
        updatePageControl()
    }
    
    // MARK: - Functions
    
    fileprivate func loopedPage(forPage page: Int) -> Int {
        return pageCount == 0
            ? 0
            : page < 0
            ? pageCount + page
            : page % pageCount
    }
    
    open func page(for indexPath: IndexPath) -> Int {
        var page = indexPath.item
        if shouldLoop {
            page -= 1
            page = loopedPage(forPage: page)
        }
        return page
    }
    
    // MARK: - UIViewController
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.showsHorizontalScrollIndicator = false
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0.0
        }
    }
    
    open override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        // addPageControl() must be called after this controller's view has a superview (eg not in viewDidLoad), so it can find an exsiting pageControl.
        addPageControl()
        updatePageControl()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTimer()
        if shouldBounce {
            showBounce()
        }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Resize cell size to fit collectionView if bounds change.
        if collectionViewSize != collectionView?.bounds.size {
            collectionViewSize = collectionView?.bounds.size
            collectionView?.isPagingEnabled = cellSize.width == collectionView!.frame.size.width
            updatePageControl(shouldUpdateCurrentPage: true)
            collectionView?.reloadData()
            if !shouldBounce {
                scroll(toPage: pageControl.currentPage, animated: false)
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension CarouselViewController {
    
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open override func collectionView(_ collectionView: UICollectionView,
                                      numberOfItemsInSection section: Int) -> Int
    {
        return pageCount + (shouldLoop ? 2 : 0)
    }
    
}

extension CarouselViewController: UICollectionViewDelegateFlowLayout {
    
    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return cellSize
    }
    
    var cellSize: CGSize {
        var size = collectionView!.frame.size
        if peakCellWidth != .notSet {
            size.width -= peakCellWidth
        }
        if maxCellWidth != .notSet, size.width > maxCellWidth {
            size.width = maxCellWidth
        }
        return size
    }
    
}

// MARK: - UIScrollViewDelegate

extension CarouselViewController {
    
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            updatePageControl(shouldUpdateCurrentPage: collectionViewSize.map { $0 == scrollView.frame.size} ?? false)
        }
    }
    
    open override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if shouldLoop {
            scroll(toPage: currentPage, animated: false)
        }
    }
    
}

private extension CGFloat {
    static let notSet: CGFloat = -1.0
}

private extension Double {
    static let notSet: Double = -1.0
}
