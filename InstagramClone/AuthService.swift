//
//  AuthService.swift
//  InstagramClone
//
//  Created by Adauto Oliveira on 08/02/20.
//  Copyright © 2020 universotec Team. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    static func signIn(email: String, password: String, onSuccess: @escaping ()->Void, onError: @escaping (_ errorMessage: String?)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onError(error?.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping ()->Void, onError: @escaping (_ errorMessage: String?)->Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user: AuthDataResult?, error: Error?) in
            if error != nil {
                onError(error?.localizedDescription)
                return
            }
            let uid = Auth.auth().currentUser?.uid
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("profile_image").child(uid!)
            
            storageRef.putData(imageData, metadata: nil) { (_, error: Error?) in
                if error != nil {
                    return
                }
                storageRef.downloadURL { (metadata: URL?, error: Error?) in
                    if let profileImageUrl = metadata?.absoluteString {
                        self.setUserInformation(profileImageUrl: profileImageUrl, username: username, email: email, uid: uid!, onSuccess: onSuccess)
                    }
                    
                }
            }
        }
    }
    
    
    static func setUserInformation(profileImageUrl: String, username: String, email: String, uid: String, onSuccess: @escaping ()->Void) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "email": email, "profileImage": profileImageUrl])
        onSuccess()
        
    }
    
    
}
