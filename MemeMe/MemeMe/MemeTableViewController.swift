//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Stephen Fong on 4/8/15.
//  Copyright (c) 2015 Stephen Fong. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var memes: [Meme]!
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Shared memes access between Table View and Collection View
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Display the Meme Editor when the app is first laumched
        if memes.isEmpty {
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let navCon = storyboard.instantiateViewControllerWithIdentifier("MemeEditorNavCon") as UINavigationController
            self.presentViewController(navCon as UIViewController, animated: true, completion: nil)
        }
        
        // Reload table view when a meme is added
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    let reuseIdentifier = "MemeTableViewCell"
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as UITableViewCell

        // The table view cell is configured as Subtitle style in the Interface Builder
        // Display content of topTextField as title, content of bottomTextField as subtitle, and memedImage
        cell.textLabel?.text = memes[indexPath.row].topText
        cell.detailTextLabel?.text = memes[indexPath.row].bottomText
        cell.imageView?.image = memes[indexPath.row].memedImage

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Set table view cell row height to 100
        return 100
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Present detail view when a table view cell is selected
        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as DetailViewController
        detailViewController.image = memes[indexPath.row].memedImage    // Pass the memedImage from the selected cell to the detail view
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
    
}
