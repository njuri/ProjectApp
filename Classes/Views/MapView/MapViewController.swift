//
//  MapViewController.swift
//  ProjectApp
//
//  Created by Juri Noga on 04.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MapKit
import CoreLocation

class MapViewController: UIViewController {
  
  var postsWithCoordinates : [PostObject] = []
  
  var annotations : [MKAnnotation] = []
  
  @IBOutlet weak var mapView: MKMapView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Map"
    
  }
  
  override func viewWillAppear(animated: Bool) {
    getPosts()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func getPosts(){
    postsWithCoordinates.removeAll()
    
    if let user = PFUser.currentUser(){
      FeedClient.downloadPostsForUser(user, forProfile: false, completion: { (objects, error) in
        if let objects = objects where error == nil{
          for object in objects{
            if let _ = object.location{
              self.postsWithCoordinates.append(object)
            }
          }
        }else{
          print(error?.localizedDescription)
        }
        self.updateMap()
      })
    }
  }
  
  
  func updateMap(){
    
    annotations.removeAll()
    for post in postsWithCoordinates{
      let coordinate = CLLocationCoordinate2D(latitude: post.locationCoordinates!.0, longitude: post.locationCoordinates!.1)
      
      let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
      
      mapView.region = region
      
      //let title = "dsfg"
      
      let ann = MKPointAnnotation()
      ann.coordinate = post.location!
      
      annotations.append(ann)
      
    }
    
    mapView.showAnnotations(annotations, animated: false)
  }
  
}




extension MapViewController : MKMapViewDelegate{
  
  func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
    mapView.deselectAnnotation(view.annotation, animated: true)
    
    let post = postsWithCoordinates.filter{$0.location! == view.annotation!.coordinate}.first!
    
    let vc = PostViewController(nibName:"PostViewController", bundle:nil)
    vc.post = post
    
    navigationController?.pushViewController(vc, animated: true)
    
  }
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    let post = postsWithCoordinates.filter{$0.location! == annotation.coordinate}.first!
    
    let mk = MKAnnotationView(annotation: annotation, reuseIdentifier: "PhotoAnnotation")
    mk.frame = CGRect(x: mk.frame.origin.x, y: mk.frame.origin.y, width: 50, height: 50)
    let imageView = PFImageView(frame: mk.frame)
    imageView.contentMode = .ScaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.masksToBounds = true
    imageView.layer.borderColor = UIColor(white: 0.4, alpha: 1).CGColor
    imageView.layer.borderWidth = 1
    imageView.layer.cornerRadius = imageView.frame.height/2
    if let file = post.imageFile{
      imageView.file = file
      imageView.loadInBackground()
    }
    
    mk.addSubview(imageView)
    
    return mk
    
  }
  
}


func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D)->Bool{
  return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}