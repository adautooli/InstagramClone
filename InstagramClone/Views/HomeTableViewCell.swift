//
//  HomeTableViewCell.swift
//  InstagramClone
//
//  Created by Adauto Oliveira on 14/02/20.
//  Copyright © 2020 universotec Team. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var homeVC: HomeViewController?
    var postRef: DatabaseReference!
    
    var post: Post?{
        didSet{
            updateView()
        }
    }
    
    var user: User?{
        didSet{
            setupUserInfo()
        }
    }
    
    func updateView() {
        captionLabel.text = post?.caption
        selectionStyle = .none
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl, completed: nil)
        }
        updateLike(post: post!)
//        Api.Post.REF_POSTS.child(post!.id!).observeSingleEvent(of: .value) { (snapshot) in
//            if let dict = snapshot.value as? [String: Any]{
//                           let post = Post.tranformPost(dict: dict, key: snapshot.key)
//                           self.updateLike(post: post)
//                       }
//        }
        Api.Post.REF_POSTS.child(post!.id!).observe(.childChanged) { (snapshot) in
            if let value = snapshot.value as? Int {
                self.likeCountButton.setTitle("\(value) likes", for: .normal)
            }
        }
            
    }
    
    func updateLike(post: Post){
        let imageName = post.likes == nil || !post.isLike! ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        guard let count = post.likeCount else {return}
        if count != 0 {
            likeCountButton.setTitle("\(count) likes", for: .normal)
        }else {
            likeCountButton.setTitle("Be the first like this ", for: .normal)
        }
    }
    func setupUserInfo() {
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, completed: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        captionLabel.text = ""
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentImageView_TouchUpInside))
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
        
        let tapGestureForLikeImageView = UITapGestureRecognizer(target: self, action: #selector(self.likeImageView_TouchUpInside))
               likeImageView.addGestureRecognizer(tapGestureForLikeImageView)
               likeImageView.isUserInteractionEnabled = true
        
        
        
    }
    @objc func likeImageView_TouchUpInside(){
        postRef = Api.Post.REF_POSTS.child(post!.id!)
        incrementLikes(forRef: postRef )
        
    }
    
    func incrementLikes(forRef ref: DatabaseReference){
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
          if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
            var likes: Dictionary<String, Bool>
            likes = post["likes"] as? [String : Bool] ?? [:]
            var likeCount = post["likeCount"] as? Int ?? 0
            if let _ = likes[uid] {
              likeCount -= 1
              likes.removeValue(forKey: uid)
            } else {
              likeCount += 1
              likes[uid] = true
            }
            post["likeCount"] = likeCount as AnyObject?
            post["likes"] = likes as AnyObject?

            currentData.value = post

            return TransactionResult.success(withValue: currentData)
          }
          return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
          if let error = error {
            print(error.localizedDescription)
          }
            if let dict = snapshot?.value as? [String: Any]{
                let post = Post.tranformPost(dict: dict, key: snapshot!.key)
                self.updateLike(post: post)
            }
        }
    }
    
    @objc func commentImageView_TouchUpInside(){
        
        print("commentImageView_TouchUpInside")
        if let id = post?.id{
            homeVC?.performSegue(withIdentifier: "CommentSegue", sender: id)
        }
        
        
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "placeholderImg")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
