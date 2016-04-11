//
//  UserProfileViewController.swift
//  ProjectApp
//
//  Created by Juri Noga on 09.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserProfileViewController: UIViewController {
  
  @IBOutlet weak var userProfileImageView: PFImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var user : PFUser!
  var posts : [PostObject] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    collectionView.registerNib(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
    
    userProfileImageView.layer.masksToBounds = true
    userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height/2
    
    user.fetchInBackgroundWithBlock { (user, error) in
      if let user = user as? PFUser{
        self.title = user.username
        self.userProfileImageView.file = user["profileImageFile"] as? PFFile
        self.userProfileImageView.loadInBackground()
      }
    }
    
    collectionView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0)
    
    automaticallyAdjustsScrollViewInsets = false;
    
    downloadUsersPosts()
  }
  
  func downloadUsersPosts(){
    FeedClient.downloadPostsForUser(user, forProfile: true) { (objects, error) in
      if let objects = objects where error == nil{
        self.posts = objects.sort{ $0.createdAt?.compare($1.createdAt!) == .OrderedDescending}
        self.collectionView.reloadData()
      }else{
        print(error?.localizedDescription)
      }
    }
  }
  
}

extension UserProfileViewController : UICollectionViewDataSource{
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
    if let file = posts[indexPath.item].imageFile{
      cell.photoImageView.file = file
      cell.photoImageView.loadInBackground()
    }
    
    return cell
  }
}

extension UserProfileViewController : UICollectionViewDelegate{
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let post = posts[indexPath.item]
    let vc = PostViewController(nibName:"PostViewController", bundle:nil)
    vc.post = post
    
    navigationController?.pushViewController(vc, animated: true)
    
  }
}

extension UserProfileViewController : UICollectionViewDelegateFlowLayout{
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let size = view.frame.width/3-1.5
    return CGSize(width: size, height: size)
  }
}

