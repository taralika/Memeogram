//
//  ViewController.swift
//  Memeogram
//
//  Created by taralika on 2/26/19.
//  Copyright © 2019 at. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var memeImgView: UIImageView!
    @IBOutlet weak var topTxt: UITextField!
    @IBOutlet weak var bottomTxt: UITextField!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var memeView: UIView!
    
    var memedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTextField(tf: topTxt, text: "TOP")
        setupTextField(tf: bottomTxt, text: "BOTTOM")
        shareBtn.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        cameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupTextField(tf: UITextField, text: String) {
        tf.defaultTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -4.0,
        ]
        tf.textColor = UIColor.white
        tf.tintColor = UIColor.white
        tf.textAlignment = .center
        tf.text = text
        tf.delegate = self
    }

    @IBAction func pickImageFromAlbum(_ sender: UIBarButtonItem) {
        chooseImageFromCameraOrPhoto(source: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: UIBarButtonItem) {
        chooseImageFromCameraOrPhoto(source: .camera)
    }
    
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem)
    {
        memeImgView.image = nil
        shareBtn.isEnabled = false
        topTxt.text = topTxt.placeholder
        bottomTxt.text = bottomTxt.placeholder
        
        // Dismiss the editor on cancel
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            memeImgView.image = image
            memeImgView.contentMode = .scaleAspectFit
            shareBtn.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.text == topTxt.placeholder || textField.text == bottomTxt.placeholder
        {
            textField.text?.removeAll()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        view.endEditing(true)
        return false
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if bottomTxt.isFirstResponder
        {
            if view.frame.origin.y == 0
            {
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
                {
                    view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        view.frame.origin.y = 0
    }
    
    @IBAction func shareBtnPressed(_ sender: UIBarButtonItem)
    {
        UIGraphicsBeginImageContext(memeView.frame.size)
        memeView.drawHierarchy(in: memeImgView.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activityVC = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed
            {
                self.save()
                
                // Dismiss editor after saving the meme
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityVC, animated: true, completion: nil)
        
        // for iPad
        if let popOver = activityVC.popoverPresentationController
        {
            popOver.sourceView = view
            popOver.barButtonItem = shareBtn
        }
    }
    
    func save()
    {
        let meme = Meme(topText: topTxt.text!, bottomText: bottomTxt.text!, originalImage: memeImgView.image!, memedImage: memedImage!)
        
        // Store the meme so we can show it in "sent memes"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
}
