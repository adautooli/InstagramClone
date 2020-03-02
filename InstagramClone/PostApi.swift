//
//  PostApi.swift
//  InstagramClone
//
//  Created by Adauto Oliveira on 17/02/20.
//  Copyright © 2020 universotec Team. All rights reserved.
//

import Foundation
import FirebaseDatabase
class PostApi {
    var REF_POSTS = Database.database().reference().child("posts")
    
    
    func  observePosts(completion: @escaping (Post)->Void) {
        REF_POSTS.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newpost = Post.tranformPost(dict: dict, key: snapshot.key)
                completion(newpost)
            }
        }
    }
    func observePost(withId id: String, completion: @escaping (Post)->Void){
        REF_POSTS.child(id).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let post = Post.tranformPost(dict: dict, key: snapshot.key)
                completion(post)
            }
        }
    }
}
