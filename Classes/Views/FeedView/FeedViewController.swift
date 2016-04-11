//
//  FeedViewController.swift
//  ProjectApp
//
//  Created by Juri Noga on 04.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import Parse
import MapKit

class FeedViewController: UIViewController, UserSelectionDelegate, LocationSelectionDelegate {
  
  @IBOutlet weak var addButton: UIBarButtonItem!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var emptyView: UIView!
  @IBOutlet weak var emptyViewIndicator: UIActivityIndicatorView!
  @IBOutlet weak var emptyViewLabel: UILabel!
  @IBOutlet weak var emptyViewIcon: UIImageView!
  @IBOutlet weak var tintView: UIView!
  
  @IBOutlet weak var locationPreviewView: UIView!
  @IBOutlet weak var locationMapView: MKMapView!
  
  var posts : [PostObject] = []{
    didSet{
      emptyView.hidden = posts.count>0
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    tableView.registerNib(UINib(nibName: "FeedViewCell", bundle: nil), forCellReuseIdentifier: "FeedViewCell")
    tableView.tableFooterView = UIView()
    title = "Feed"
    downloadPosts()
    
    locationPreviewView.layer.masksToBounds = true
    locationPreviewView.layer.cornerRadius = 6
    locationPreviewView.layer.borderWidth = 1
    locationPreviewView.layer.borderColor = UIColor.darkGrayColor().CGColor
    
    tintView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FeedViewController.hideMapPreviewLocation)))
    
  }
  
  func downloadPosts(){
    
    emptyViewIndicator.startAnimating()
    emptyViewIcon.hidden = true
    emptyViewLabel.text = "Downloading posts"
    
    posts.removeAll()
    
    if let user = PFUser.currentUser(){
      FeedClient.downloadPostsForUser(user, forProfile: false) { (objects, error) in
        if let objects = objects where error == nil{
          
          self.posts = objects.sort{ $0.createdAt?.compare($1.createdAt!) == .OrderedDescending}
          self.tableView.reloadData()
          self.emptyViewIcon.hidden = false
          self.emptyViewIndicator.stopAnimating()
          self.emptyViewLabel.text = "Feed is empty"
          
        }else{
          print(error?.localizedDescription)
        }
      }
    }
  }
  
  func showTintView(){
    UIView.animateWithDuration(0.2) {
      self.tintView.alpha = 1
    }
  }
  
  func hideTintView(){
    UIView.animateWithDuration(0.2) {
      self.tintView.alpha = 0
    }
  }
  
  func showMapPreview(){
    UIView.animateWithDuration(0.2) {
      self.locationPreviewView.alpha = 1
    }
  }
  
  func hideMapPreview(){
    UIView.animateWithDuration(0.2) {
      self.locationPreviewView.alpha = 0
    }
  }
  
  func didSelectLocation(coordinates: CLLocationCoordinate2D) {
    showTintView()
    showMapPreview()
    
    let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    locationMapView.region = region
    let ann = MKPointAnnotation()
    ann.coordinate = coordinates
    locationMapView.showAnnotations([ann], animated: false)
    
    
  }
  
  func hideMapPreviewLocation(){
    hideTintView()
    hideMapPreview()
  }
  
  
  @IBAction func addPressed(sender: AnyObject) {
    let vc = AddPostViewController(nibName:"AddPostViewController", bundle:nil)
    vc.delegate = self
    let nc = UINavigationController(rootViewController: vc)
    presentViewController(nc, animated: true, completion: nil)
  }
  
  func didSelectUser(user: PFUser) {
    let vc = UserProfileViewController(nibName:"UserProfileViewController", bundle:nil)
    vc.user = user
    navigationController?.pushViewController(vc, animated: true)
  }
  
}

// MARK: - UITableViewDataSource

extension FeedViewController : UITableViewDataSource{
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("FeedViewCell") as! FeedViewCell
    let post = posts[indexPath.row]
    cell.setToPost(post)
    cell.delegate = self
    cell.locationDelegate = self
    return cell
  }
}

// MARK: - UITableViewDelegate

extension FeedViewController : UITableViewDelegate{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let post = posts[indexPath.row]
    
    let vc = PostViewController(nibName:"PostViewController", bundle:nil)
    vc.post = post
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let staticHeight : CGFloat = 15+28+25+view.frame.width
    let post = posts[indexPath.row]
    let locationHeight : CGFloat
    if let _ = post.location{
      locationHeight = 4+15+8
    }else{
      locationHeight = 0
    }
    
    let textHeight = post.text!.heightWithConstrainedWidth(view.frame.width-16, font: UIFont.systemFontOfSize(13),optionalHeight: (15+3)*3)+16
    
    return staticHeight+textHeight+locationHeight
  }
}

extension FeedViewController : AddPostDelegate{
  func createdPost(post: PostObject) {
    posts.insert(post, atIndex: 0)
    tableView.reloadData()
    post.upload { (success) in
      print(success)
      if success == true{
        self.downloadPosts()
      }
    }
    
  }
}

extension String {
  func heightWithConstrainedWidth(width: CGFloat, font: UIFont, optionalHeight : CGFloat?) -> CGFloat {
    let constraintRect : CGSize
    if let h = optionalHeight{
      constraintRect = CGSize(width: width, height: h)
    }else{
      constraintRect = CGSize(width: width, height: CGFloat.max)
    }
    let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    return boundingBox.height
  }
}
