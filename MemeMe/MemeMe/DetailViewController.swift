//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Stephen Fong on 4/8/15.
//  Copyright (c) 2015 Stephen Fong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    // MARK: - View Controller Life Cyclle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Display memedImage
        self.imageView!.image = image
    }


}
