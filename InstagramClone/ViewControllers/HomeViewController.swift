//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Adauto Oliveira on 04/02/20.
//  Copyright © 2020 universotec Team. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 521
        tableView.dataSource = self
        loadPosts()
    }
    
    
    func loadPosts(){
        activityIndicatorView.startAnimating()
        Api.Post.observePosts { (post) in
            guard let postId = post.uid else {return}
            self.fetchUser(uid: postId) {
                self.posts.append(post)
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            }
        }
        
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        Api.User.observeUser(with: uid) { (user) in
            self.users.append(user)
            completed()
        }
    }
    @IBAction func logout_TouchUpInside(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentSegue"{
            let commentVC = segue.destination as! CommentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
    }
    
    
    
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.homeVC = self
        return cell
    }
    
    
}
