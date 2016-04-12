//
//  FeedViewCell.swift
//  ProjectApp
//
//  Created by Juri Noga on 04.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationSelectionDelegate{
  func didSelectLocation(coordinates : CLLocationCoordinate2D)
}

class FeedViewCell: UITableViewCell {
  
  @IBOutlet weak var userIconView: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var postImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var locationIconView: UIImageView!
  @IBOutlet weak var locationButton: UIButton!
  
  @IBOutlet weak var circleProgressView: CircleProgressView!
  
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
    
    userIconView.layer.masksToBounds = true
    userIconView.layer.cornerRadius = userIconView.frame.height/2
    
    
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
