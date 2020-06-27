//
//  Item.swift
//  eMarkt
//
//  Created by Alex Codreanu on 26/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import Foundation
import UIKit

class Item {
    //MARK: - item properties
    var id: String!
    var categoryID: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    
    init(){}
    
    init(_dictionary: NSDictionary){
        
        id = _dictionary[kOBJECT] as? String
        categoryID = _dictionary[kCATEGORYID] as? String
        name = _dictionary[kNAME] as? String
        description = _dictionary[kDESCRIPTION] as? String
        price = _dictionary[kPRICE] as? Double
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
    }
}
//MARK: - Save items
func saveItemsToFirebase(_ item: Item){
    
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String : Any])
}

//MARK: - Helper functions
func itemDictionaryFrom(_ item: Item) -> NSDictionary{
    return NSDictionary(objects: [item.id, item.categoryID, item.name, item.description, item.price, item.imageLinks],
                        forKeys: [kOBJECT as NSCopying, kCATEGORYID as NSCopying, kNAME as NSCopying, kDESCRIPTION as NSCopying,
                                  kPRICE as NSCopying, kIMAGELINKS as NSCopying])
}

//MARK: - Download items from Firebase
func downloadItemsFromFirebase(withCategoryID: String, completion: @escaping (_ itemArray: [Item]) -> Void){
    
    var itemArray: [Item] = []
    
    FirebaseReference(.Items).whereField(kCATEGORYID, isEqualTo: withCategoryID).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(itemArray)
            return
        }
        
        if !snapshot.isEmpty{
            for item in snapshot.documents{
                itemArray.append(Item(_dictionary: item.data() as NSDictionary))
            }
        }
        completion(itemArray)
    }
}

//MARK: - Download items from Firebase by itemID
func downloadItemsFromFirebaseByItemID(withIDs: [String], completion: @escaping (_ itemArray : [Item]) -> Void){
    
    //EXPLANATION: - every item found will be downloaded and added
    //EXPLANATION: - into the itemArray and once the counter reaches
    //EXPLANATION: - the amount of sent IDs, the callback will be called
    var count = 0
    var itemArray: [Item] = []
    
    if withIDs.count > 0 {
        for itemID in withIDs {
            FirebaseReference(.Items).document(itemID).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else {
                    completion(itemArray)
                    return
                }
                if snapshot.exists {
                    //EXPLANATION: - if there is data inside the snapshot received from Firebase
                    //EXPLANATION: - the itemArray will append a new Item, created by usind the
                    //EXPLANATION: - data inside the snapshot, as a NSDictionary
                    itemArray.append(Item(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                } else {
                    completion(itemArray)
                    return
                }
                
                //EXPLANATION: - if the counter incremented in this function
                //EXPLANATION: - has the same value as the size of the ID Array
                //EXPLANATION: - received by the function, the completion callback
                //EXPLANATION: - can be called, as all items were appended
                if count == withIDs.count {
                    completion(itemArray)
                }
            }
        }
    } else {
        completion(itemArray)
    }
}

