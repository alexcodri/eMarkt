//
//  Downloader.swift
//  eMarkt
//
//  Created by Alex Codreanu on 26/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage()

func uploadImages(images: [UIImage?], itemId: String, completion: @escaping (_ imageLinks: [String]) -> Void) {
    if Reachabilty.HasConnection() {
        
        var uploadedImagesCount = 0
        var imageLinkArray: [String] = []
        var nameSuffix = 0
        
        for image in images {
            
            let fileName = "ItemImages/" + itemId + "/" + "\(nameSuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.5)
            saveImageInFirebase(imageData: imageData!, fileName: fileName) { (imageLink) in
                
                if imageLink != nil {
                    imageLinkArray.append(imageLink!)
                    uploadedImagesCount += 1
                    
                    if uploadedImagesCount == images.count{
                        completion(imageLinkArray)
                    }
                }
            }
            nameSuffix += 1
        }
    } else {
        print("No Internet Connection")
    }
}

func saveImageInFirebase(imageData: Data, fileName: String,
                         completion: @escaping (_ imageLing: String?) -> Void){
    var task: StorageUploadTask!
    let storageReference = storage.reference(forURL: kFILEREFERENCE).child(fileName)
    
    task = storageReference.putData(imageData, metadata: nil, completion: { (metadata, error) in
        task.removeAllObservers()
        
        if error != nil{
            print("Error uploading image!", error!.localizedDescription)
            completion(nil)
            return
        } else {
            storageReference.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }
                completion(downloadURL.absoluteString)
            }
        }
    })
}

func downloadImagesFromFirebase(_ imageURLs : [String], completion: @escaping (_ images: [UIImage?])-> Void){
    
    var imageArray: [UIImage] = []
    
    var imageCounter = 0
    
    for link in imageURLs{
        let url = NSURL(string: link)
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        
        downloadQueue.async {
            imageCounter += 1
            
            let data = NSData(contentsOf: url! as URL)
            
            if data != nil{
                //there are images from url
                imageArray.append(UIImage(data: data! as Data)!)
                if imageCounter == imageArray.count{
                    //if there are no more images to fetch
                    //the main thread is called in order to
                    //call the completion handler
                    DispatchQueue.main.async {
                        completion(imageArray)
                    }
                } else {
                    print("Couldn't download images!")
                    completion(imageArray)
                }
                
            }
        }
    }
    
}
