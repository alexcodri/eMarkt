//
//  AddItemViewController.swift
//  eMarkt
//
//  Created by Alex Codreanu on 26/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView


class AddItemViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var cameraButton: UIButton!
    
    
    //MARK: - Variables
    
    var category: Category!
    var itemImages: [UIImage?] = []
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    
    var activityIndicator: NVActivityIndicatorView?
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: .black, padding: nil)
    }
    
    //MARK: - IBActions
    
    @IBAction func doneBarButtonItemPressed(_ sender: Any) {
        dismissKeyboard()
        if checkFieldsAreCompleted(){
            saveToFirebase()
        } else {
            print("Error! All fields are required!")
            self.hud.textLabel.text = "All fields are required!"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        itemImages = []
        showImageGallery()
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    //MARK: - Helper functions
    
    private func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    private func checkFieldsAreCompleted() -> Bool{
        return (titleTextField.text != "" &&
            priceTextField.text != "" &&
            descriptionTextView.text != "")
    }
    
    private func dismissView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Save item to Firebase
    private func saveToFirebase(){
        
        showLoadingIndicator()
        let item = Item()
        
        item.id = UUID().uuidString
        item.name = titleTextField.text!
        item.categoryID = category.id
        item.description = descriptionTextView.text
        item.price = Double(priceTextField.text!)
        
        if itemImages.count > 0 {
            uploadImages(images: itemImages, itemId: item.id) { (imageLinkArray) in
                item.imageLinks = imageLinkArray
                saveItemsToFirebase(item)
                self.hideLoadingIndicator()
                self.dismissView()
            }
        } else {
            saveItemsToFirebase(item)
            self.hideLoadingIndicator()
            dismissView()
        }
        
    }
    //MARK: - Activity Indicator
    private func showLoadingIndicator(){
        if activityIndicator != nil{
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    private func hideLoadingIndicator(){
        if activityIndicator != nil{
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    //MARK: - Show gallery
    private func showImageGallery(){
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallery, animated: true, completion: nil)
    }
    
}
//MARK: - Protocols
extension AddItemViewController: GalleryControllerDelegate{
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            Image.resolve(images: images) { (resolvedImages) in
                self.itemImages = resolvedImages
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
}
