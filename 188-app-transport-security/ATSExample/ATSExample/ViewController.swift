//
//  ViewController.swift
//  ATSExample
//
//  Created by Ben Scheirman on 9/20/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: "https://www.imdb.com")!
        let request = NSURLRequest(URL: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if let err = error {
                print("ERROR: \(err)")
            } else {
                let http = response as! NSHTTPURLResponse
                print("HTTP \(http.statusCode)")
            }
        }
        task.resume()
    }
}

