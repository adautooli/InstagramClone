//
//  Comment.swift
//  InstagramClone
//
//  Created by Adauto Oliveira on 16/02/20.
//  Copyright © 2020 universotec Team. All rights reserved.
//

import Foundation
class Comment  {
    
    var commentText: String?
    var uid: String?
    
}

extension Comment {
    static func tranformComment(dict: [String: Any]) -> Comment {
        let comment = Comment()
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        
        return comment
    }
}
