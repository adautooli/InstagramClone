//
//  Post.swift
//  InstagramClone
//
//  Created by Adauto Oliveira on 14/02/20.
//  Copyright © 2020 universotec Team. All rights reserved.
//

import Foundation
import FirebaseAuth
class Post  {
    
    var caption: String?
    var photoUrl: String?
    var uid: String?
    var id: String?
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    var isLike: Bool?
}

extension Post {
    static func tranformPost(dict: [String: Any], key: String) -> Post {
        let post = Post()
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.uid = dict["uid"] as? String
        post.id = key
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        if let currentUserId = Auth.auth().currentUser?.uid{
            if post.likes != nil {
                post.isLike = post.likes![currentUserId] != nil
            }
        }
        
        return post
    }
}
