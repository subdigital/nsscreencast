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
        let url = NSURL(string: "https://whispering-coast-30540.herokuapp.com/")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    func checkSharedWebCredentials() {
        SecRequestSharedWebCredential(nil, nil) { (results, error) in
            if let e = error {
                print("error: \(e)")
            } else {
                
                if CFArrayGetCount(results) > 0 {
                    let ptr = CFArrayGetValueAtIndex(results, 0)
                    let dict = unsafeBitCast(ptr, CFDictionary.self) as Dictionary
                    
                    let server = dict[kSecAttrServer as String] as! String
                    let user = dict[kSecAttrAccount as String] as! String
                    let password = dict[kSecSharedPassword as String] as! String
                    
                    print("Found result for \(server)")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.emailTextField.text = user
                        self.passwordTextField.text = password
                    }
                }
                
            }
        }
    }
}

