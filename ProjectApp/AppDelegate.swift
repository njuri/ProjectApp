//
//  AppDelegate.swift
//  ProjectApp
//
//  Created by Juri Noga on 03.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import Parse

struct AppStyle{
  struct Color{
    static let MainTintColor = UIColor(red: 80/255.0, green: 150/255.0, blue: 255/255.0, alpha: 1)
    static let MainBackgroundColor = UIColor(white: 0.2, alpha: 1)
    static let SecondaryTintColor = UIColor.whiteColor()
  }
  
  struct Font{
    
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    
    let config = ParseClientConfiguration(block: {
      ParseMutableClientConfiguration in
      
      ParseMutableClientConfiguration.applicationId = "myAppId";
      ParseMutableClientConfiguration.clientKey = "myClientKey";
      ParseMutableClientConfiguration.server = "https://blooming-brook-97491.herokuapp.com/parse";
      
    });
    
    Parse.enableLocalDatastore()
    Parse.initializeWithConfiguration(config);
    setupApperance()
    
    let vc : UIViewController
    
    if let _ = PFUser.currentUser(){
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      vc = storyboard.instantiateViewControllerWithIdentifier("tabbar")
    }else{
      vc = LoginViewController(nibName:"LoginViewController", bundle:nil)
    }
    
    
    self.window?.rootViewController = vc
    self.window?.makeKeyAndVisible()
    
    return true
  }
  
  func setupApperance(){
    UINavigationBar.appearance().barTintColor = AppStyle.Color.MainBackgroundColor
    UINavigationBar.appearance().tintColor = AppStyle.Color.SecondaryTintColor
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : AppStyle.Color.SecondaryTintColor]
    UINavigationBar.appearance().translucent = false
    
    UITabBar.appearance().translucent = false
    UITabBar.appearance().barTintColor = AppStyle.Color.MainBackgroundColor
    UITabBar.appearance().tintColor = AppStyle.Color.MainTintColor
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

