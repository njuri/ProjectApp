//
//  PostObject.swift
//  ProjectApp
//
//  Created by Juri Noga on 04.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import CoreLocation

struct PostObject{
  var text : String?
  var image : UIImage?
  var location : CLLocationCoordinate2D?
  var locationCoordinates : (Double,Double)?{
    if let location = location{
    return (location.latitude,location.longitude)
    }else{
      return nil
    }
  }
  
  var createdAt : NSDate?
  
  static func parsedPost(object : NSDictionary)->PostObject{
    let text = object["text"] as? String
    let coordinates = object["coordinates"] as? [Double]
    
    
    let post : PostObject
    if let coord = coordinates where coord.count == 2{
      post = PostObject(text: text, image: nil, location: CLLocationCoordinate2D(latitude: coord[0],longitude:coord[1]), createdAt: object["createdAt"] as? NSDate)
    }else{
      post = PostObject(text: text, image: nil, location: nil, createdAt: object["createdAt"] as? NSDate)
 
    }
    
    return post
  }
  
  
  func upload(completion: (success : Bool)->Void){
  }
  


}
