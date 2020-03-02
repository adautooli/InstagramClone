//
//  PhotoCollectionViewCell.swift
//  InstagramClone
//
//  Created by Adauto Oliveira on 18/02/20.
//  Copyright © 2020 universotec Team. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    var post: Post? {
        didSet{
            updateView()
        }
    }
    func updateView(){
    if let photoUrlString = post?.photoUrl {
        let photoUrl = URL(string: photoUrlString)
        photo.sd_setImage(with: photoUrl, completed: nil)
        
        }
    }
}
