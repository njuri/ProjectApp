//
//  LoginViewController.swift
//  ProjectApp
//
//  Created by Juri Noga on 11.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var appNameLabel: UILabel!
  @IBOutlet weak var loginButton: UIView!
  @IBOutlet weak var indicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    view.backgroundColor = AppStyle.Color.MainBackgroundColor
    loginButton.tintColor = AppStyle.Color.MainTintColor
    appNameLabel.textColor = AppStyle.Color.SecondaryTintColor
    
    appNameLabel.text = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? String
    
    emailTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
    passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  @IBAction func loginPressed(sender: AnyObject) {
    loginButton.hidden = true
    indicator.startAnimating()
    
    let user = PFUser()
    user.email = "example@example.com"
    user.username = emailTextField.text
    user.password = passwordTextField.text
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier("tabbar")
    
    user.signUpInBackgroundWithBlock({ (success, error) in
      if error == nil{
        print("Sucess")
        self.presentViewController(vc, animated:true, completion: nil)
      }else{
        if error?.code == 202 || error?.code == 203 {
          PFUser.logInWithUsernameInBackground(user.username!, password: user.password!, block: { (user, error) in
            if error == nil{
            self.presentViewController(vc, animated: true, completion: nil)
            }else{
              print(error?.localizedDescription)
              self.indicator.stopAnimating()
              self.loginButton.hidden = false
            }
          })
        }else{
          self.indicator.stopAnimating()
          self.loginButton.hidden = false
          print(error?.localizedDescription)
        }
      }
    })

  }
}
