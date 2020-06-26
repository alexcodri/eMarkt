//
//  CategoryCollectionViewController.swift
//  eMarkt
//
//  Created by Alex Codreanu on 26/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import UIKit

class CategoryCollectionViewController: UICollectionViewController {
    
    //MARK: Variables
    //all downloaded categories will be stored in this array
    var categoriesArray: [Category] = []
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //function was called once, populating Firebase with categories.
        //createCategorySet()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCategories()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    //MARK: Download categories
    private func loadCategories(){
        downloadCategoriesFromFirebase{ (allCategories) in
            self.categoriesArray = allCategories
            //after all the categories will be downloaded, the collectionView
            //must be refreshed in order to present the new data
            self.collectionView.reloadData()
        }
    }
}
