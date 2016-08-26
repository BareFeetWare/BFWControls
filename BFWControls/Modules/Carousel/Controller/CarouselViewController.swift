//
//  CarouselViewController.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 16/03/2016.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

import UIKit

class CarouselViewController: UICollectionViewController {
    
    // MARK: - Variables
    
    @IBInspectable var controlInsetBottom: CGFloat = 0.0
    
    /// Looped from last back to first page.
    @IBInspectable var looped: Bool = false
    
    // MARK: - Static content
    
    /// Cell identifiers for finite static content.
    @IBInspectable var cell0Identifier: String?
    @IBInspectable var cell1Identifier: String?
    @IBInspectable var cell2Identifier: String?
    @IBInspectable var cell3Identifier: String?
    @IBInspectable var cell4Identifier: String?
    @IBInspectable var cell5Identifier: String?
    @IBInspectable var cell6Identifier: String?
    @IBInspectable var cell7Identifier: String?

    /// Name of plist file containing cell identifiers for long static content.
    @IBInspectable var dataSourcePlistName: String?
    
    /// Override in subclass for dynamic content or use default implementation for static content.
    var cellIdentifiers: [String]? {
        return plistDict?[Key.cellIdentifiers] as? [String] ?? ibCellIdentifiers
    }
    
    private struct Key {
        static let cellIdentifiers = "cellIdentifiers"
    }
    
    private var ibCellIdentifiers: [String] {
        return [cell0Identifier,
            cell1Identifier,
            cell2Identifier,
            cell3Identifier,
            cell4Identifier,
            cell5Identifier,
            cell6Identifier,
            cell7Identifier
            ].flatMap { $0 }
    }
    
    private var plistDict: [String: AnyObject]? {
        return NSBundle.mainBundle().pathForResource(dataSourcePlistName, ofType: "plist").flatMap {
            NSDictionary(contentsOfFile: $0) as? [String: AnyObject]
        }
    }
    
    // MARK: - Override in subclass for dynamic content

    /// Override in subclass for dynamic content or use default implementation for static content.
    var pageCount: Int {
        return cellIdentifiers?.count ?? 0
    }
    
    /// Override in subclass for dynamic content or use default implementation for static content.
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let page = pageForIndexPath(indexPath)
        let cellIdentifier = cellIdentifiers![page]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        return cell
    }
    
    // MARK: - Variables
    
    var currentPage: Int {
        return Int(round(currentPageFloat))
    }
    
    var currentPageFloat: CGFloat {
        return currentCellItem - (shouldLoop ? 1 : 0)
    }
    
    var pageControl = UIPageControl()
    var collectionViewSize: CGSize?
    
    // MARK: - Private variables
    
    private var shouldLoop: Bool {
        return looped && pageCount > 1
    }
    
    private var currentCellItem: CGFloat {
        return collectionView!.contentOffset.x / collectionViewSize!.width
    }
    
    // MARK: - Actions
    
    private func addPageControl() {
        collectionView?.addSubview(pageControl)
        pageControl.addTarget(self,
                              action: #selector(changedPageControl(_:)),
                              forControlEvents: .ValueChanged)
        pageControl.numberOfPages = pageCount
        pageControl.sizeToFit()
    }
    
    @IBAction func changedPageControl(pageControl: UIPageControl) {
        scrollToPage(pageControl.currentPage, animated: true)
    }
    
    private func updatePageControl() {
        if let collectionViewSize = collectionViewSize {
            pageControl.frame.origin.x = (collectionViewSize.width - pageControl.frame.width) / 2 + collectionView!.contentOffset.x
            pageControl.frame.origin.y = collectionViewSize.height - pageControl.frame.height + collectionView!.contentOffset.y - controlInsetBottom
            pageControl.currentPage = loopedPageForPage(currentPage)
        }
    }
    
    private func scrollToPage(page: Int, animated: Bool) {
        let loopedPage = loopedPageForPage(page)
        let scrolledPage = loopedPage + (shouldLoop ? 1 : 0)
        let indexPath = NSIndexPath(forItem: scrolledPage, inSection: 0)
        collectionView?.scrollToItemAtIndexPath(indexPath,
                                                atScrollPosition: .CenteredHorizontally,
                                                animated: animated)
    }
    
    // MARK: - Functions
    
    private func loopedPageForPage(page: Int) -> Int {
        return page < 0 || pageCount == 0 ? pageCount + page : page % pageCount
    }
    
    func pageForIndexPath(indexPath: NSIndexPath) -> Int {
        var page = indexPath.row
        if shouldLoop {
            page -= 1
            page = loopedPageForPage(page)
        }
        return page
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPageControl()
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .Horizontal
            layout.minimumInteritemSpacing = 0.0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Resize cell size to fit collectionView if bounds change.
        if collectionViewSize != collectionView?.bounds.size {
            collectionViewSize = collectionView?.bounds.size
            collectionView?.reloadData()
            scrollToPage(0, animated: false)
            updatePageControl()
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension CarouselViewController {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int
    {
        return pageCount + (shouldLoop ? 2 : 0)
    }
    
}

extension CarouselViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return collectionView.frame.size
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 0.0
    }
    
}

// MARK: - UIScrollViewDelegate

extension CarouselViewController {
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == collectionView {
            updatePageControl()
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if shouldLoop {
            scrollToPage(currentPage, animated: false)
        }
    }
    
}