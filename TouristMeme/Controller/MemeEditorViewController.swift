//
//  MemesEditorViewController.swift
//  TouristMeme
//
//  Created by Saad on 12/13/19.
//  Copyright © 2019 saad. All rights reserved.
//

import Foundation

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate ,UITextFieldDelegate {
    
    
    
    
    var image : UIImage?
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor:
            UIColor.black ,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3.3
    ]
    
    @IBOutlet weak var pickingImageView: UIImageView!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var album: UIBarButtonItem!
    @IBOutlet weak var flickrButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = false
        //        cancel.isEnabled = false
        
        
        
        texts(topField)
        texts(bottomField)
        
        
    }
    func texts(_ sender : UITextField){
        sender.textAlignment = .center
        sender.defaultTextAttributes = memeTextAttributes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        self.navigationController?.isNavigationBarHidden = true
        if !(UIImagePickerController.isSourceTypeAvailable(.camera)){
            cameraButton.isEnabled = false
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldDidBeginEditing(_ sender: UITextField) {
        sender.text = ""
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Mark: Keyboard shows
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Mark: Keyboard Hides
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        
        if sender == cancel{
            pickingImageView.image = nil
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.popToRootViewController(animated: true)
            
            
        }
        else if sender == cameraButton{
            pickAnImage(from: .camera)
        }
        else if sender == album{
            pickAnImage(from: .photoLibrary)
        }
    }
    func pickAnImage(from source: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = source
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickingImageView.contentMode = .scaleAspectFit
            pickingImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
        cancel.isEnabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func barHidden( bar :Bool){
        if bar {
            self.topToolBar.isHidden = bar
            self.bottomToolBar.isHidden = bar
        }
        else {
            self.topToolBar.isHidden = false
            self.bottomToolBar.isHidden = false
        }
    }
    @IBAction func picFromflickr (_ sender : UIBarButtonItem){
        pickingImageView.image = image
        shareButton.isEnabled = true
     
    }
    func generateMemedImage() -> UIImage {
        
        //  Hide toolbar and navbar
        
        barHidden(bar: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        barHidden(bar: false)
        return memedImage
    }
    func saveMeme(_ memeImage: UIImage?) {
        
        let meme = Meme(topText: topField.text!,
                        bottomText: bottomField.text!,
                        originalImage: pickingImageView.image!,
                        meamedImage: generateMemedImage() )
        
        // Add to array
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        
        
    }
    
    @IBAction func shareFunction(_ sender: UIBarButtonItem) {
        let image = generateMemedImage()
        let items : [Any] = ["This is my memed photo", image]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if let wPPC = ac.popoverPresentationController {
            wPPC.sourceView = self.view
            //  or
            wPPC.barButtonItem = shareButton
        }
        
        present(ac, animated: true)
        
        ac.completionWithItemsHandler = {
            (_, completed, _, _) in
            
            if completed {
                self.saveMeme(image)
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    
}
