//
//  FirebaseCollectionReference.swift
//  eMarkt
//
//  Created by Alex Codreanu on 26/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import Foundation
import FirebaseFirestore

//the categories that will exist in Firebase
enum FCollectionReference: String{
    case User
    case Category
    case Items
    case Basket
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference{
    //getting the specific value for the collection
    return Firestore.firestore().collection(collectionReference.rawValue)
}
