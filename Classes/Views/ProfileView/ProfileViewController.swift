//
//  ProfileViewController.swift
//  ProjectApp
//
//  Created by Juri Noga on 04.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import Parse

class SettingsObject {
  var currentUser = UserObject(userID:"",profileImage: UIImage(named: "leo.jpg"),username: "njuri"){
    didSet{
      if let user = PFUser.currentUser(){
        let file = PFFile(data: UIImageJPEGRepresentation(SettingsObject.resizeImage(currentUser.profileImage!, newSize: CGSize(width: 70,height: 70)), 0.3)!)
        user["profileImageFile"] = file
        user.username = currentUser.username
        user.saveInBackground()
      }
    }
  }
  
  class func resizeImage(image: UIImage, newSize: CGSize) -> (UIImage) {
    let newRect = CGRectIntegral(CGRectMake(0,0, newSize.width, newSize.height))
    let imageRef = image.CGImage
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    let context = UIGraphicsGetCurrentContext()
    
    // Set the quality level to use when rescaling
    let flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height)
    
    CGContextConcatCTM(context, flipVertical)
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef)
    
    let newImageRef = CGBitmapContextCreateImage(context) as CGImage!
    let newImage = UIImage(CGImage: newImageRef)
    
    // Get the resized image from the context and a UIImage
    UIGraphicsEndImageContext()
    
    return newImage
  }
  
  
  static let settings = SettingsObject()
}



class ProfileViewController: UIViewController,UINavigationControllerDelegate{
  
  @IBOutlet weak var tableView: UITableView!
  
  var mainCell : MainProfileViewCell?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    title = "Profile"
    tableView.registerNib(UINib(nibName: "MainProfileViewCell", bundle: nil), forCellReuseIdentifier: "MainProfileViewCell")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func editImagePressed(){
    Presenter.showSourceTypeSheet(self, delegate: self)
  }
  
  
}


// MARK: - UITableViewDataSource

extension ProfileViewController : UITableViewDataSource{
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MainProfileViewCell") as! MainProfileViewCell
    cell.editButton.addTarget(self, action: #selector(ProfileViewController.editImagePressed), forControlEvents: .TouchUpInside)
    cell.userNameField.text = SettingsObject.settings.currentUser.username
    cell.profileImageView.image = SettingsObject.settings.currentUser.profileImage
    cell.profileImageView.layer.masksToBounds = true
    cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height/2
    
    PFUser.currentUser()!.fetchInBackgroundWithBlock { (user, error) in
      if let user = user as? PFUser{
        cell.userNameField.text = user.username
        cell.profileImageView.file = user["profileImageFile"] as? PFFile
        cell.profileImageView.loadInBackground()
      }
    }
    
    mainCell = cell
    return cell
  }
}

// MARK: - UITableViewDelegate

extension ProfileViewController : UITableViewDelegate{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 90
  }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController : UIImagePickerControllerDelegate{
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    mainCell?.profileImageView.image = image
    SettingsObject.settings.currentUser.profileImage = image
    dismissViewControllerAnimated(true, completion: nil)
  }
}