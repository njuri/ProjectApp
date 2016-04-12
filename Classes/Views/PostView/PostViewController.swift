//
//  PostViewController.swift
//  ProjectApp
//
//  Created by Juri Noga on 09.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
  
  @IBOutlet weak var postImageView: UIImageView!
  @IBOutlet weak var authorImageView: UIImageView!
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
    

    
    postTextLabel.text = post.text
    dateLabel.text = post.createdAt!.toString(dateStyle: .ShortStyle, timeStyle: .NoStyle, doesRelativeDateFormatting: true).lowercaseString
    
    if let image = post.image{
      postImageView.image = image
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
}
