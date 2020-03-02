//
//  User.swift
//  InstagramClone
//
//  Created by Adauto Oliveira on 14/02/20.
//  Copyright © 2020 universotec Team. All rights reserved.
//

import Foundation
class User  {
    var email: String?
    var profileImageUrl: String?
    var username: String?
}

extension User {
    static func transformUser(dict: [String: Any]) -> User {
        let user = User()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImage"] as? String
        user.username = dict["username"] as? String
        return user
    }
}
