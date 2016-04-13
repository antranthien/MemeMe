//
//  ViewController.swift
//  MemeMe
//
//  Created by admin on 23/03/16.
//  Copyright © 2016 antt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate  {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textFieldTop: UITextField!
    
    @IBOutlet weak var textFieldBottom: UITextField!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var toolbarTop: UIToolbar!

    
    @IBOutlet weak var toolbarBottom: UIToolbar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textFieldTop.defaultTextAttributes = Constants.Meme.textAttributes
        textFieldBottom.defaultTextAttributes = Constants.Meme.textAttributes
        textFieldTop.textAlignment = .Center
        textFieldBottom.textAlignment = .Center
        
        textFieldTop.delegate = self
        textFieldBottom.delegate = self
        
        textFieldTop.tag = Constants.Meme.Tag.top
        textFieldBottom.tag = Constants.Meme.Tag.bottom
        
        // disable Share button by default
        shareButton.enabled = false

    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // disable the camera button if it´s not supported (in simulators)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        // hide the status bar
        return true
    }


    @IBAction func cancelImage(sender: AnyObject) {
        // clear the image
        imageView.image = nil
        
        // set textfields back to default values
        textFieldTop.text = Constants.Meme.DefaultText.top
        textFieldBottom.text = Constants.Meme.DefaultText.bottom
        
        // disable the Share button
        shareButton.enabled = false
    }
    
    
    @IBAction func shareMemedImage(sender: AnyObject) {
        let image = generateMemedImage()
        
        // Pass the Meme image to the Activity Controller
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save(image)
                controller.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }
        presentViewController(controller, animated: true, completion: nil)
    }
    
    private func save(memedImage : UIImage) {
        //Create the meme
        let meme = Meme( topText: textFieldTop.text!, bottomText: textFieldBottom.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage
    {
        // hide toolbars
        toolbarTop.hidden = true
        toolbarBottom.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolbarTop.hidden = false
        toolbarBottom.hidden = false
        
        return memedImage
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if textFieldBottom.isFirstResponder(){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }

        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if textFieldBottom.isFirstResponder(){
            view.frame.origin.y += getKeyboardHeight(notification)
        }
        
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)) , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)) , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    

}

// UIImagePicker Delegate
extension ViewController : UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = selectedImage
            
            shareButton.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectAPhotoFromAlbum(sender: AnyObject) {
        selectAPhotoFromASource(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func selectAPhotoFromCamera(sender: AnyObject) {
        selectAPhotoFromASource(UIImagePickerControllerSourceType.Camera)
    }
    
    // sourceType is nil: Camera source
    private func selectAPhotoFromASource(sourceType : UIImagePickerControllerSourceType){
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        if sourceType == UIImagePickerControllerSourceType.Camera {
            imagePicker.allowsEditing = true

        }
        
        // display an Image Picker ViewController
        presentViewController(imagePicker, animated: true, completion: nil)

        
    }

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

// TextField Delagate
extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // empty the default text when editing
        if (textField.tag == Constants.Meme.Tag.top && textField.text == Constants.Meme.DefaultText.top)
         || (textField.tag == Constants.Meme.Tag.bottom  && textFieldBottom.text == Constants.Meme.DefaultText.bottom) {
            textField.text = ""
        }
        
        
        return true
    }
}

