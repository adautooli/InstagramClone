//
//  UserApi.swift
//  InstagramClone
//
//  Created by Adauto Oliveira on 17/02/20.
//  Copyright © 2020 universotec Team. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserApi {
    var REF_USERS = Database.database().reference().child("users")
    
    func observeUser(with uid: String, completion: @escaping (User)->Void ){
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
           if let dict = snapshot.value as? [String: Any] {
            let user = User.transformUser(dict: dict)
                completion(user)
            }
        }
    }
    func observeCurrentUser(completion: @escaping (User)->Void ){
        guard let currentUser = Auth.auth().currentUser else {
                  return 
               }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value) { (snapshot) in
           if let dict = snapshot.value as? [String: Any] {
            let user = User.transformUser(dict: dict)
                completion(user)
            }
        }
    }
    var REf_CURRENT_USER: DatabaseReference? {
        guard let currentUSer = Auth.auth().currentUser else {
           return nil
        }
        return REF_USERS.child(currentUSer.uid)
    }
}
