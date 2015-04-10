//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Stephen Fong on 4/8/15.
//  Copyright (c) 2015 Stephen Fong. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    var memes: [Meme]!
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Shared memes access between Table View and Collection View
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        
        // Reload collection view when a meme is added
        self.collectionView?.reloadData()
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return 0 if memes count is nil, otherwise return memes count as number of items in section
        if let count = memes?.count {
            return count
        } else {
            return 0
        }
    }
    
    let reuseIdentifier = "MemeCollectionViewCell"

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as MemeCollectionViewCell
    
        // Display memedImage in the collection view
        let meme = memes[indexPath.row]
        cell.imageView?.image = meme.memedImage
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Present detail view when a collection view cell is selected
        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as DetailViewController
        detailViewController.image = memes[indexPath.row].memedImage    // Pass the memedImage from the selected cell to the detail view
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let picDimension = self.view.frame.size.width / 4.0
        return CGSizeMake(picDimension, picDimension)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }


}
