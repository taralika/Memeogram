//
//  ViewController.swift
//  Memeogram
//
//  Created by taralika on 2/26/19.
//  Copyright © 2019 at. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var memeImgView: UIImageView!
    @IBOutlet weak var topTxt: UITextField!
    @IBOutlet weak var bottomTxt: UITextField!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var memeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topTxt.delegate = self
        bottomTxt.delegate = self
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

    @IBAction func pickImageFromAlbum(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem)
    {
        memeImgView.image = nil
        shareBtn.isEnabled = false
        topTxt.text = topTxt.placeholder
        bottomTxt.text = bottomTxt.placeholder
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
        self.view.endEditing(true)
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
        //memeImgView.layer.render(in: UIGraphicsGetCurrentContext()!)
        memeView.drawHierarchy(in: memeImgView.frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activityVC = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}
