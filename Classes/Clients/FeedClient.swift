//
//  FeedClient.swift
//  ProjectApp
//
//  Created by Juri Noga on 11.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import Foundation
import Parse

class FeedClient{
  
  class func downloadPostsForUser(user : PFUser, forProfile : Bool, completion : (objects : [PostObject]?, error : NSError?)->()){
    let q = PFQuery(className: "PostObject")
    if forProfile == true{
      q.whereKey("author", equalTo: user)
    }
    q.findObjectsInBackgroundWithBlock { (objects, error) in
      q.orderByAscending("createdAt")
      
      guard let objects = objects where error == nil else{
        completion(objects: nil, error: error)
        return
      }
      
      var posts : [PostObject] = []
      
      for object in objects{
        posts.append(PostObject.parsedPost(object))
      }
      
      PFObject.pinAllInBackground(objects)
      completion(objects: posts, error: nil)
      
    }
    
  }
  
  
  
}