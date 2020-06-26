//
//  Category.swift
//  eMarkt
//
//  Created by Alex Codreanu on 26/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import Foundation
import UIKit

class Category {
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(_name: String, _imageName: String){
        id = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init(_dictionary: NSDictionary){
        id = _dictionary[kOBJECT] as! String
        name = _dictionary[kNAME] as! String
        image = UIImage(named: _dictionary[kIMAGENAME] as? String ?? "")
    }
}

//MARK: Download categories function from Firebase
//once every category is downloaded and saved, the function will return
//an array of Categories
func downloadCategoriesFromFirebase(completion: @escaping (_ categoryArray: [Category])->Void){
    
    var categoryArray: [Category] = []
    
    FirebaseReference(.Category).getDocuments { (snapshot, error) in
        //verifying if the snapshot from Firebase is empty
        guard let snapshot = snapshot else {
            completion(categoryArray)
            return
        }
        //if it is not empty, each category will be appended to the categoryArray
        if !snapshot.isEmpty{
            for categoryDictionary in snapshot.documents{
                categoryArray.append(Category.init(_dictionary: categoryDictionary.data() as NSDictionary))
                
            }
        }
        completion(categoryArray)
    }
}

//MARK: Save category functions to Firebase
func saveCategoryToFirebase(_ category: Category){
    //unique id
    let id = UUID().uuidString
    category.id = id
    
    FirebaseReference(.Category).document(id).setData(categoryDictionaryFrom(category) as! [String : Any])
}

//MARK: Helpers
func categoryDictionaryFrom(_ category: Category) -> NSDictionary{
    //this will create a dictionary and return all objects from the categories.
    return NSDictionary(objects: [category.id, category.name, category.imageName], forKeys: [kOBJECT as NSCopying, kNAME as NSCopying, kIMAGENAME as NSCopying])
}

//use only once for creating the categories in Firebase
func createCategorySet(){
    
    let womenClothing = Category(_name: "Women's Clothing & Accessories", _imageName: "womenCloth")
    let footWear = Category(_name: "Footwear", _imageName: "footWear")
    let electronics = Category(_name: "Electronics", _imageName: "electronics")
    let menClothing = Category(_name: "Men's Clothing & Accessories" , _imageName: "menCloth")
    let health = Category(_name: "Health & Beauty", _imageName: "health")
    let baby = Category(_name: "Baby Stuff", _imageName: "baby")
    let home = Category(_name: "Home & Kitchen", _imageName: "home")
    let car = Category(_name: "Automobiles & Motorcyles", _imageName: "car")
    let luggage = Category(_name: "Luggage & bags", _imageName: "luggage")
    let jewelery = Category(_name: "Jewelery", _imageName: "jewelery")
    let hobby =  Category(_name: "Hobby, Sport, Traveling", _imageName: "hobby")
    let pet = Category(_name: "Pet products", _imageName: "pet")
    let industry = Category(_name: "Industry & Business", _imageName: "industry")
    let garden = Category(_name: "Garden supplies", _imageName: "garden")
    let camera = Category(_name: "Cameras & Optics", _imageName: "camera")
    
    let arrayOfCategories = [womenClothing, footWear, electronics, menClothing, health, baby, home, car, luggage, jewelery, hobby, pet, industry, garden, camera]
    
    for category in arrayOfCategories {
        saveCategoryToFirebase(category)
    }
    
}
