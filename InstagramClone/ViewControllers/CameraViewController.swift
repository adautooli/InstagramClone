//
//  CameraViewController.swift
//  InstagramClone
//
//  Created by Adauto Oliveira on 04/02/20.
//  Copyright © 2020 universotec Team. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class CameraViewController: UIViewController {
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePOST()
    }
    
    func handlePOST(){
        if selectedImage != nil {
            shareButton.isEnabled = true
            removeButton.isEnabled = true
            shareButton.backgroundColor = .black
        }else {
            shareButton.isEnabled = false
            removeButton.isEnabled = false
            shareButton.backgroundColor = .lightGray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.modalPresentationStyle = .fullScreen
        present(pickerController, animated: true, completion: nil)
    }
    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
        ProgressHUD.show("Waiting", interaction: false)
        if let imageData = selectedImage?.jpegData(compressionQuality: 0.1){
            let photoIdString = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("posts").child(photoIdString)
            storageRef.putData(imageData, metadata: nil) { (_, error: Error?) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                storageRef.downloadURL { (metadata: URL?, error: Error?) in
                    if let photoUrl = metadata?.absoluteString {
                        self.sendDataToDatabase(photoUrl: photoUrl)
                    }
                    
                }
            }
        }else {
            ProgressHUD.showError("Escolha uma Foto para postas")
            
        }
    }
    @IBAction func remove_TouchUpInside(_ sender: UIBarButtonItem) {
        clean()
        handlePOST()
    }
    
    func sendDataToDatabase(photoUrl: String) {
        let ref = Database.database().reference()
        let postsReference = ref.child("posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostId!)
        guard let currentUser = Auth.auth().currentUser else {return}
        let currentUserId = currentUser.uid
        newPostReference.setValue(["uid": currentUserId, "photoUrl": photoUrl, "caption": captionTextView.text!]) { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
           let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child(newPostId!)
            myPostRef.setValue(true) { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                
                
            }
        
            ProgressHUD.showSuccess("Succes")
            self.clean()
            self.tabBarController?.selectedIndex = 0
        }
        
        
        
    }
    
    func clean(){
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "Placeholder-image")
        self.selectedImage = nil
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage){
            selectedImage = image
            photo.image = image
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
