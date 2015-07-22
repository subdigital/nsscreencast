//
//  LoginViewController.swift
//  OperationScreencast
//
//  Created by Ben Scheirman on 7/21/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

@objc protocol LoginViewControllerDelegate {
    func loginViewControllerDidLogin(loginViewController: LoginViewController)
}

class LoginViewController : UITableViewController, UITextFieldDelegate {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var delegate: LoginViewControllerDelegate?
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.hidesWhenStopped = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }
    
    @IBAction func submit(button: UIBarButtonItem!) {
        button.enabled = false
        activityIndicator.startAnimating()
        
        let delayInMs = NSEC_PER_MSEC * UInt64(1200)
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInMs))
        dispatch_after(when, dispatch_get_main_queue()) {
            self.activityIndicator.stopAnimating()
            button.enabled = true
            
            if !self.emailTextField.text.isEmpty && self.passwordTextField.text == "password" {
                self.loginSuccess()
            } else {
                self.loginFailure()
            }
        }
    }
    
    func loginSuccess() {
        AuthStore.instance.login("asdf123")
        delegate?.loginViewControllerDidLogin(self)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loginFailure() {
        let alert = UIAlertController(title: "Invalid Login", message: "Please check your credentials and try again", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            submit(navigationItem.rightBarButtonItem)
        }
        return false
    }
}