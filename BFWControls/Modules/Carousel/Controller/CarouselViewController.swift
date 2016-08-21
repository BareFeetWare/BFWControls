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
    @IBInspectable var cell0Identifier: String?
    @IBInspectable var cell1Identifier: String?
    @IBInspectable var cell2Identifier: String?
    @IBInspectable var cell3Identifier: String?
    @IBInspectable var cell4Identifier: String?
    @IBInspectable var cell5Identifier: String?
    @IBInspectable var cell6Identifier: String?
    @IBInspectable var cell7Identifier: String?
    
    @IBInspectable var dataSourcePlistName: String?
    
    var cellIdentifiers: [String]? {
        return plistDict?[Key.cellIdentifiers] as? [String] ?? ibCellIdentifiers
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
        let plistDict: [String: AnyObject]?
        if let plistPath = NSBundle.mainBundle().pathForResource(dataSourcePlistName, ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: plistPath) as? [String: AnyObject]
        {
            plistDict = dict
        } else {
            plistDict = nil
        }
        return plistDict
    }
    
    private var collectionViewSize: CGSize?
    private var pageControl = UIPageControl()
    
    // MARK: - Actions
    
    private func addPageControl() {
        collectionView?.addSubview(pageControl)
        pageControl.addTarget(self,
                              action: #selector(changedPageControl(_:)),
                              forControlEvents: .ValueChanged)
        pageControl.numberOfPages = cellIdentifiers?.count ?? 3
        pageControl.sizeToFit()
    }
    
    @IBAction func changedPageControl(pageControl: UIPageControl) {
        scrollToPage(pageControl.currentPage)
    }
    
    private func scrollToPage(page: Int) {
        let indexPath = NSIndexPath(forItem: page, inSection: 0)
        collectionView?.scrollToItemAtIndexPath(indexPath,
                                                atScrollPosition: .CenteredHorizontally,
                                                animated: true)
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
        return cellIdentifiers?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let reuseIdentifier = cellIdentifiers![indexPath.row]
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
            let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.size.width))
            pageControl.currentPage = page
        }
    }
    
}