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
    
    var page: Int {
        return scrolledPage - (looping ? 1 : 0)
    }
    
    var pageCount: Int {
        return cellIdentifiers?.count ?? 0
    }
    
    // MARK: - Constants
    
    private struct Key {
        static let cellIdentifiers = "cellIdentifiers"
    }
    
    // MARK: - Private Variables

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
    
    private var loopedCellIdentifiers: [String]? {
        let identifiers: [String]?
        if let cellIdentifiers = cellIdentifiers where looping {
            identifiers = [cellIdentifiers.last!] + cellIdentifiers + [cellIdentifiers.first!]
        } else {
            identifiers = cellIdentifiers
        }
        return identifiers
    }
    
    private var looping: Bool {
        return looped && (cellIdentifiers?.count ?? 0) > 1
    }
    
    private var scrolledPage: Int {
        return Int(round(collectionView!.contentOffset.x / collectionView!.bounds.size.width))
    }
    
    private var collectionViewSize: CGSize?
    private var pageControl = UIPageControl()
    
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
    
    private func scrollToPage(page: Int, animated: Bool) {
        let loopedPage = loopedPageForPage(page)
        let scrolledPage = loopedPage + (looping ? 1 : 0)
        let indexPath = NSIndexPath(forItem: scrolledPage, inSection: 0)
        collectionView?.scrollToItemAtIndexPath(indexPath,
                                                atScrollPosition: .CenteredHorizontally,
                                                animated: animated)
    }
    
    // MARK: - Functions
    
    private func loopedPageForPage(page: Int) -> Int {
        var loopedPage = page
        if page > pageCount - 1 {
            loopedPage = 0
        } else if page < 0 {
            loopedPage = pageCount - 1
        }
        return loopedPage
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .Horizontal
            layout.minimumInteritemSpacing = 0.0
        }
        addPageControl()
        scrollToPage(0, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Resize cell size to fit collectionView if bounds change.
        if collectionViewSize != collectionView?.bounds.size {
            collectionViewSize = collectionView?.bounds.size
            collectionView?.reloadData()
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
        return loopedCellIdentifiers?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let reuseIdentifier = loopedCellIdentifiers![indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        return cell
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
            pageControl.frame.origin.x = (scrollView.bounds.width - pageControl.frame.width) / 2 + scrollView.contentOffset.x
            pageControl.frame.origin.y = scrollView.bounds.height - pageControl.frame.height + scrollView.contentOffset.y - controlInsetBottom
            pageControl.currentPage = loopedPageForPage(page)
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if looping {
            scrollToPage(page, animated: false)
        }
    }
    
}