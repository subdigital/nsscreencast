//
//  LoginViewController.swift
//  EasyAuthClient
//
//  Created by Ben Scheirman on 5/23/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController {
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var authCodeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var authClient: AuthenticationClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        authCodeLabel.hidden = true
        activityIndicator.startAnimating()
        
        let clientID = UIDevice.currentDevice().identifierForVendor!.UUIDString
        authClient = AuthenticationClient(clientID: clientID)
        
        directionLabel.text = directionLabel.text?.stringByReplacingOccurrencesOfString("URL", withString: authClient.activateURLString)
        requestCode()
    }
    
    
    func requestCode() {
        authClient.requestCode { (req) in
            self.activityIndicator.stopAnimating()

            if let e = req.error {
                self.displayAlert(e)
            } else {
                self.authCodeLabel.text = req.code!
                self.authCodeLabel.hidden = false

                self.pollForStatus(req, delay: 1)
            }
        }
    }
    
    func pollForStatus(authReq: AuthenticationRequest, delay: NSTimeInterval) {
        let time: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.authClient.statusForRequest(authReq, completion: { (updatedRequest) in
                if let e = updatedRequest.error {
                    self.displayAlert(e)
                } else if updatedRequest.status == "authenticated" {
                    self.finalizeAuthentication(updatedRequest)
                } else {
                    self.pollForStatus(updatedRequest, delay: delay)
                }
            })
        }
    }
    
    
    func finalizeAuthentication(authRequest: AuthenticationRequest) {
        let authToken = deriveAuthToken(authRequest)
        AuthStore.instance.authToken = authToken
        
        NSNotificationCenter.defaultCenter().postNotificationName("LoggedIn", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func deriveAuthToken(authRequest: AuthenticationRequest) -> String {
        
        let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA1)
        
        let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
        let buffer = UnsafeMutablePointer<UInt8>.alloc(digestLength)
        
        let key = authRequest.clientID!
        let data = authRequest.authTokenData!
        
        CCHmac(algorithm, key, key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding),
               data, data.lengthOfBytesUsingEncoding(NSUTF8StringEncoding),
               buffer)
        
        var str = ""
        for i in 0..<digestLength {
            str = str.stringByAppendingFormat("%x", buffer[i])
        }

        return str
    }
    
    func displayAlert(e: NSError) {
        
        var message = e.localizedDescription
        if let body = e.userInfo["body"] as? String {
            message = body
        }
        
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}
