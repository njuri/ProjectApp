//
//  PostObject.swift
//  ProjectApp
//
//  Created by Juri Noga on 04.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import Parse
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
  var imageFile : PFFile?
  let author : PFUser
  
  var createdAt : NSDate?
  
  static func parsedPost(object : PFObject)->PostObject{
    let text = object["text"] as? String
    let imageFile = object["imageFile"] as? PFFile
    let coordinates = object["coordinates"] as? [Double]
    let author = object["author"] as? PFUser
    
    
    let post : PostObject
    if let coord = coordinates where coord.count == 2{
      post = PostObject(text: text, image: nil, location: CLLocationCoordinate2D(latitude: coord[0],longitude:coord[1]), imageFile: imageFile, author: author!, createdAt: object.createdAt)
    }else{
      post = PostObject(text: text, image: nil, location: nil, imageFile: imageFile, author: author!, createdAt: object.createdAt)
 
    }
    
    return post
  }
  
  
  func upload(completion: (success : Bool)->Void){
    if author.objectId == PFUser.currentUser()?.objectId{
      let object = PFObject(className: "PostObject")
      if let t = text{
        object["text"] = t
      }
      if let location = location{
        object["coordinates"] = [location.latitude,location.longitude]
      }
      
      if let image = image{
        let imageFile = PFFile(data: UIImageJPEGRepresentation(image, 0.5)!)
        object["imageFile"] = imageFile
        imageFile?.saveInBackgroundWithBlock({ (result, error) in
          if error != nil{
            print(error?.localizedDescription)
            completion(success: false)
          }else{
            object["author"] = self.author
            object.saveInBackgroundWithBlock({ (result, error) in
              if error == nil{
                completion(success: true)
              }else{
                completion(success: false)
              }
            })
            
          }
        })
      }
    }
    
    
    
  }

}
