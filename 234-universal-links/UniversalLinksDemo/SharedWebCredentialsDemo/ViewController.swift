//
//  ViewController.swift
//  SharedWebCredentialsDemo
//
//  Created by Ben Scheirman on 8/7/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        checkSharedWebCredentials()
    }
    
    @IBAction func openWebsiteTapped(sender: AnyObject) {
        let url = NSURL(string: "https://desolate-springs-88496.herokuapp.com/")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    func checkSharedWebCredentials() {
        SecRequestSharedWebCredential(nil, nil) { (credentials, error) in
            if let error = error {
                print("Error fetching shared web credentials: \(error)")
            } else {
                if CFArrayGetCount(credentials ?? []) > 0 {
                    let firstCredentialsPtr = CFArrayGetValueAtIndex(credentials, 0)
                    let firstCredentials = unsafeBitCast(firstCredentialsPtr, CFDictionaryRef.self) as Dictionary
                    
                    let server = firstCredentials[kSecAttrServer as String] as! String
                    let account = firstCredentials[kSecAttrAccount as String] as! String
                    let pass = firstCredentials[kSecSharedPassword as String] as! String
                    
                    print("Found match for server: \(server)")
                    
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.emailTextField.text = account
                        self.passwordTextField.text = pass
                    }
                }
            }
        }
    }
}

