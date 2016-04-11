//
//  Presenter.swift
//  ProjectApp
//
//  Created by Juri Noga on 09.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import Parse

class Presenter{
  
  class func showSourceTypeSheet(presenter : UIViewController, delegate : protocol<UIImagePickerControllerDelegate,UINavigationControllerDelegate>){
    let sheet = UIAlertController(title: "Choose source type", message: nil, preferredStyle: .ActionSheet)
    if UIImagePickerController.isSourceTypeAvailable(.Camera){
      let cameraAction = UIAlertAction(title: "Camera", style: .Default) { action in
        Presenter.showImagePickerControllerWithType(.Camera, presenter: presenter, delegate: delegate)
      }
      let photoAction = UIAlertAction(title: "Photo Library", style: .Default) {action in
        Presenter.showImagePickerControllerWithType(.PhotoLibrary,presenter: presenter, delegate: delegate)
      }
      let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
      sheet.addActions([cameraAction,photoAction,cancelAction])
      presenter.presentViewController(sheet, animated: true, completion: nil)
    }else{
      Presenter.showImagePickerControllerWithType(.PhotoLibrary, presenter: presenter, delegate: delegate)
    }
    
  }
  
  private class func showImagePickerControllerWithType(type : UIImagePickerControllerSourceType, presenter : UIViewController, delegate : protocol<UIImagePickerControllerDelegate,UINavigationControllerDelegate>){
    let vc = UIImagePickerController()
    vc.sourceType = type
    vc.allowsEditing = true
    vc.delegate = delegate
    presenter.presentViewController(vc, animated: true, completion: nil)
  }
  
  func showUserProfile(user: PFUser, presenter : UIViewController){
    
  }
}

extension UIAlertController{
  func addActions(actions : [UIAlertAction]){
    for action in actions{
      addAction(action)
    }
  }
}