//
//  HeaderProfileCollectionReusableView.swift
//  InstagramClone
//
//  Created by Adauto Oliveira on 17/02/20.
//  Copyright © 2020 universotec Team. All rights reserved.
//

import UIKit

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostCsountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    func  updateView() {
        self.nameLabel.text = user!.username
        if let photoUrlString = user!.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            self.profileImage.sd_setImage(with: photoUrl, completed: nil)
        }
    }
    
}
