//
//  ImageCollectionViewCell.swift
//  eMarkt
//
//  Created by Alex Codreanu on 27/06/2020.
//  Copyright © 2020 Alex Codreanu. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage){
        imageView.image = itemImage
    }
}
