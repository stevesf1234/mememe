//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Stephen Fong on 4/7/15.
//  Copyright (c) 2015 Stephen Fong. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let imagePicker = UIImagePickerController()

    
    // MARK: - Outlets

    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!

    
    // MARK: - Image Selection Actions

    @IBAction func pickImage(sender: UIBarButtonItem) {

        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takePicture(sender: UIBarButtonItem) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            shareButton.enabled = true  // Enable the share button after an image is selected
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Navigation Actions

    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
        
        self.memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [self.memedImage!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.completionWithItemsHandler = {
            (activity: String!, completed: Bool, items: [AnyObject]!, error: NSError!) -> Void in
            if completed {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Memed Image Generation
    
    var memedImage: UIImage!
    
    func saveMeme() {
        // Create the meme
        var meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the AppDelegate
        (UIApplication.sharedApplication().delegate as AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar
        self.bottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar
        self.bottomToolbar.hidden = false
        
        return memedImage
    }
    
    
    // MARK: - Define textField attributes
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -2.0
    ]
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        imagePicker.delegate = self
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        // Disable the share button until an image is selected
        shareButton.enabled = false
        
        // Set top textField attributes
        topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: memeTextAttributes)
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.borderStyle = .None
        topTextField.textAlignment = .Center
        
        // Set bottom textField attributes
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: memeTextAttributes)
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.borderStyle = .None
        bottomTextField.textAlignment = .Center

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard notification to raise or lower the view
        self.subsribeToKeyboardNotification()
        
        // Enabel camera button if camera is available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.unscribeFromKeyboardNotification()
    }
    
    
    // MARK: - Keyboard Notification Subscription
    
    func subsribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unscribeFromKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    
    // MARK: - Keyboard Delegate
    
    var textFieldBottom: CGFloat = 0.0
    
    // Dismiss keyboard on return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = getKeyboardHeight(notification)
        let keyboardTopFromOrigin = self.view.frame.height - keyboardHeight
        
        // Move the view up by the height of the keyboard if bottom of the textField
        // is located lower than the height of the keyboard
        if textFieldBottom > keyboardTopFromOrigin {
            self.view.frame.origin.y -= keyboardHeight
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textFieldBottom = textField.frame.origin.y + textField.frame.height
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue  // of CGRect
        return keyboardSize.CGRectValue().height
    }



}
