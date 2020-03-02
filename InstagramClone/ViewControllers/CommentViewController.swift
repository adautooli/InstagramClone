//
//  CommentViewController.swift
//  InstagramClone
//
//  Created by Adauto Oliveira on 15/02/20.
//  Copyright © 2020 universotec Team. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CommentViewController: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    
    
    
    
    var postId : String!
    var comments = [Comment]()
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comment"
        tableView.dataSource = self
        tableView.estimatedRowHeight = 77
        tableView.dataSource = self
        sendButton.isEnabled = false
        handleTextField()
        loadComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration:0.3 ) {
            self.constraintToBottom.constant -= keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
    }
    
    
    @objc func keyboardWillHide(_ notification: NSNotification){
        UIView.animate(withDuration:0.3 ) {
            self.constraintToBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    func loadComments()  {
        
        
        Api.Post_Comment.REF_POST_COMMENTS.child(self.postId).observe(.childAdded) { (snapshot) in
            Api.Comment.observeComment(withPostId: snapshot.key) { (comment) in
                self.fetchUser(uid: comment.uid!) {
                    self.comments.append(comment)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        
        Api.User.observeUser(with: uid) { (user) in
            self.users.append(user)
            completed()
        }
        
    }
    
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    
    
    @objc func textFieldDidChange() {
        if let commentText = commentTextField.text, !commentText.isEmpty{
            sendButton.setTitleColor(UIColor.white, for: .normal)
            sendButton.isEnabled = true
            return
        }
        
        sendButton.setTitleColor(UIColor.lightGray, for: .normal)
        sendButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func sendButton_TouchUpInside(_ sender: Any) {
        let commentsReference = Api.Comment.REF_COMMENTS
        let newCommentId = commentsReference.childByAutoId().key
        let newCommentReference = commentsReference.child(newCommentId!)
        guard let currentUser = Auth.auth().currentUser else {return}
        let currentUserId = currentUser.uid
        newCommentReference.setValue(["uid": currentUserId, "commentText": commentTextField.text!]) { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            let postCommentRef = Api.Post_Comment.REF_POST_COMMENTS.child(self.postId).child(newCommentId!)
            postCommentRef.setValue(true) { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                
                
            }
            ProgressHUD.showSuccess("Succes Comment :)")
            self.empty()
            self.view.endEditing(true)
        }
    }
    
    func empty() {
        self.commentTextField.text = ""
        self.sendButton.isEnabled = false
        self.sendButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comment = comment
        cell.user = user
        return cell
    }
    
    
}
