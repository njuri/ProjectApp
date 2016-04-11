//
//  PostViewController.swift
//  ProjectApp
//
//  Created by Juri Noga on 09.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostViewController: UIViewController {
  
  @IBOutlet weak var postImageView: PFImageView!
  @IBOutlet weak var authorImageView: PFImageView!
  @IBOutlet weak var authorNameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var postTextLabel: UILabel!
  
  var post : PostObject!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    setToPost()
    setNeedsStatusBarAppearanceUpdate()
    
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  func setToPost(){
    
    authorImageView.layer.masksToBounds = true
    authorImageView.layer.cornerRadius = authorImageView.frame.height/2
    
    post.author.fetchInBackgroundWithBlock { (user, error) in
      self.authorNameLabel.text = self.post.author.username
      self.authorImageView.file = self.post.author["profileImageFile"] as? PFFile
      self.authorImageView.loadInBackground()
    }
    
    postTextLabel.text = post.text
    dateLabel.text = post.createdAt!.toString(dateStyle: .ShortStyle, timeStyle: .NoStyle, doesRelativeDateFormatting: true).lowercaseString
    
    if let image = post.image{
      postImageView.image = image
    }else if let file = post.imageFile{
      postImageView.file = file
      postImageView.loadInBackground({ (image, error) in
      })
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
}
