//
//  MyPostApi.swift
//  InstagramClone
//
//  Created by Adauto Oliveira on 17/02/20.
//  Copyright © 2020 universotec Team. All rights reserved.
//

import Foundation
import FirebaseDatabase
class MyPostApi {
    var REF_MYPOSTS = Database.database().reference().child("myPosts")
    
}
