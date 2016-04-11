//
//  AddPostViewController.swift
//  ProjectApp
//
//  Created by Juri Noga on 04.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import CoreLocation
import Parse
import Photos

protocol AddPostDelegate {
  func createdPost(post : PostObject)
}

class AddPostViewController: UIViewController,UINavigationControllerDelegate {
  
  var post = PostObject(text:nil,image:nil,location:nil,imageFile: nil,author:PFUser.currentUser()!,createdAt:NSDate())
  let locationManager = CLLocationManager()
  var delegate : AddPostDelegate?
  
  @IBOutlet weak var postImageView: UIImageView!
  @IBOutlet weak var postTextView: UITextView!
  
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var locationIconView: UIImageView!
  @IBOutlet weak var addButton: UIButton!
  
  @IBOutlet weak var locationIconConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(white: 0.96, alpha: 1)
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(AddPostViewController.closePressed))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .Done, target: self, action: #selector(AddPostViewController.postPressed))
    navigationController?.navigationBar.translucent = false;
    
    locationIconView.image = locationIconView.image?.imageWithRenderingMode(.AlwaysTemplate)
    locationIconView.tintColor = AppStyle.Color.MainTintColor
    
    navigationItem.leftBarButtonItem?.tintColor = locationIconView.tintColor
    navigationItem.rightBarButtonItem?.tintColor = locationIconView.tintColor
    title = "New post"
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func addLocationPressed(sender: AnyObject) {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  @IBAction func addPhotoPressed(sender: AnyObject) {
    Presenter.showSourceTypeSheet(self, delegate: self)
  }
  
  func closePressed(){
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func postPressed(){
    post.text = postTextView.text
    post.createdAt = NSDate()
    delegate?.createdPost(post)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func locationError(){
    let ac = UIAlertController(title: "No location enabled", message: "Please turn on location for this app in settings", preferredStyle: .Alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
    presentViewController(ac, animated: true, completion: nil)
  }
}

extension AddPostViewController : UIImagePickerControllerDelegate{
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    print("hello")
    
    if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
      
      if let assetURL = info[UIImagePickerControllerReferenceURL] as? NSURL{

        let result = PHAsset.fetchAssetsWithALAssetURLs([assetURL], options: nil).firstObject as! PHAsset
        if let loc = result.location{
          self.post.location = loc.coordinate
        }
      }
      
      
      
    
      
      post.image = image
      postImageView.image = image
      postImageView.alpha = 1
      postImageView.contentMode = .ScaleAspectFill
      addButton.setTitle("", forState: .Normal)
      dismissViewControllerAnimated(true, completion: nil)
      
    }
    
    
  }
}

extension AddPostViewController : CLLocationManagerDelegate{
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    print(error.localizedDescription)
    locationError()
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    switch status{
    case .NotDetermined:
      print("not determined")
    case .Restricted:
      print("not determined")
      locationError()
      print("restricted")
    case .Denied:
      print("denied")
      locationError()
    case .AuthorizedWhenInUse:
      locationManager.startUpdatingLocation()
    case .AuthorizedAlways:
      locationManager.startUpdatingLocation()
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print(locations)
    post.location = locations[0].coordinate
    locationLabel.text = "\(locations[0].coordinate.latitude.roundToDecimalPlaces(4)) \(locations[0].coordinate.longitude.roundToDecimalPlaces(4))"
    locationIconView.image = UIImage(named:"marker-filled")?.imageWithRenderingMode(.AlwaysTemplate)
    locationManager.stopUpdatingLocation()
    locationIconConstraint.constant = 8
    UIView.animateWithDuration(0.2) {
      self.view.layoutIfNeeded()
    }
  }
}

extension Double{
  func roundToDecimalPlaces(decimals : Int)->Double{
    if decimals < 0{
      return self
    }else{
      let power = pow(10.0,Double(decimals))
      return round(power*self)/power
    }
  }
}