//
//  Algolia.swift
//  eMarkt
//
//  Created by Alex Codreanu on 29/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import Foundation
import InstantSearchClient

class AlgoliaService {
    
    static let shared = AlgoliaService()
    
    let client = Client(appID: kALGOLIA_APP_ID, apiKey: kALGOLIA_ADMIN_KEY)
    let index = Client(appID: kALGOLIA_APP_ID, apiKey: kALGOLIA_ADMIN_KEY).index(withName: "item_name")
    private init(){}
}
