//
//  FeedViewCell.swift
//  ProjectApp
//
//  Created by Juri Noga on 04.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import ParseUI
import Parse

protocol UserSelectionDelegate{
  func didSelectUser(user : PFUser)
}

protocol LocationSelectionDelegate{
  func didSelectLocation(coordinates : CLLocationCoordinate2D)
}

class FeedViewCell: UITableViewCell {
  
  @IBOutlet weak var userIconView: PFImageView!
  @IBOutlet weak var userNameButton: UserNameButton!
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var postImageView: PFImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var locationIconView: UIImageView!
  @IBOutlet weak var locationButton: UIButton!
  
  @IBOutlet weak var circleProgressView: CircleProgressView!
  
  var delegate : UserSelectionDelegate?
  var locationDelegate : LocationSelectionDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setToPost(post : PostObject){
    
    userNameButton.tintColor = AppStyle.Color.MainTintColor
    userIconView.layer.masksToBounds = true
    userIconView.layer.cornerRadius = userIconView.frame.height/2
    
    post.author.fetchInBackgroundWithBlock { (user, error) in
      self.userNameButton.setTitle(post.author.username
, forState: .Normal)
      self.userIconView.file = post.author["profileImageFile"] as? PFFile
      self.userIconView.loadInBackground()
    }
    
    descriptionLabel.text = post.text
    
    dateLabel.text = post.createdAt!.toString(dateStyle: .ShortStyle, timeStyle: .NoStyle, doesRelativeDateFormatting: true).lowercaseString
    if let coordinates = post.locationCoordinates{
      locationIconView.hidden = false
      locationButton.setTitle("\(coordinates.0) \(coordinates.1)", forState: .Normal)
    }else{
      locationButton.setTitle("", forState: .Normal)
      locationIconView.hidden = true
    }
    
    if let img = post.image{
      postImageView.image = img
    } else if let file = post.imageFile{
      postImageView.file = file
      print(file.url)
      postImageView.loadInBackground({ (image, error) in
        
        }, progressBlock: { (progress) in
          //print(progress)
          if progress == 100{
            self.circleProgressView.hidden = true
          }else{
            self.circleProgressView.setProgress(Double(progress)/100, animated: false)
          }
      })
    }
  }
  
  @IBAction func userNamePressed(sender: AnyObject) {
    let q = PFQuery(className: "_User")
    print(userNameButton.titleLabel!.text!)
    q.whereKey("username", equalTo: userNameButton.titleLabel!.text!)
    q.getFirstObjectInBackgroundWithBlock { (user , error) in
      if let user = user as? PFUser{
        self.delegate?.didSelectUser(user)
      }
    }
  }
  
  @IBAction func locationPressed(sender: AnyObject) {
    let title = locationButton.titleForState(.Normal)
    let coords = title?.componentsSeparatedByString(" ")
    if let coords = coords where coords.count == 2 {
      if let lat = Double(coords[0]), long = Double(coords[1]){
        let coordinates = CLLocationCoordinate2DMake(lat, long)
        locationDelegate?.didSelectLocation(coordinates)
      }
    }
    
    
  }
}

class UserNameButton : UIButton{
  var user : PFUser?
}
