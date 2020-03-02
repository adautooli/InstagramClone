//
//  CommentApi.swift
//  InstagramClone
//
//  Created by Adauto Oliveira on 17/02/20.
//  Copyright © 2020 universotec Team. All rights reserved.
//

import Foundation
import FirebaseDatabase
class CommentApi {
    var REF_COMMENTS = Database.database().reference().child("comments")
    
    func observeComment(withPostId id: String, completion: @escaping (Comment)->Void ) {
        REF_COMMENTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                let newComment = Comment.tranformComment(dict: dict)
                completion(newComment)
            }
        }
    }
    
}
