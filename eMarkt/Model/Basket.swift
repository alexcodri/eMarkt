//
//  Basket.swift
//  eMarkt
//
//  Created by Alex Codreanu on 27/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import Foundation

class Basket{
    var id: String!
    var ownerID: String!
    var itemIDs: [String]!
    
    init(){}
    
    init(_dictionary: NSDictionary){
        id = _dictionary[kOBJECT] as? String
        ownerID = _dictionary[kOWNERID] as? String
        itemIDs = _dictionary[kITEMIDS] as? [String]
    }
}

//MARK: - Download items
func downloadBasketFromFirebase(_ ownerID: String, completion: @escaping (_ basket: Basket?)-> Void){
    FirebaseReference(.Basket).whereField(kOWNERID, isEqualTo: ownerID).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(nil)
            return
        }
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(basket)
        } else {
            completion(nil)
        }
    }
}


//MARK: - Save to firebase
func saveBasketToFirebase(_ basket: Basket){
    FirebaseReference(.Basket).document(basket.id)
        .setData(basketDictionaryFrom(basket) as! [String : Any])
}

//MARK: - Helper function
func basketDictionaryFrom(_ basket: Basket) -> NSDictionary{
    return NSDictionary(objects: [basket.id, basket.ownerID, basket.itemIDs],
                        forKeys: [kOBJECT as NSCopying,kOWNERID as NSCopying, kITEMIDS as NSCopying ])
}

//MARK: - Update basket
func updateBasketInFirebase(_ basket: Basket, withValues: [String : Any],
                            completion: @escaping (_ error : Error?) -> Void){
    
    
    FirebaseReference(.Basket).document(basket.id).updateData(withValues) { (error) in
        completion(error)
    }
    
}
