//
//  ViewController.swift
//  OperationBasics
//
//  Created by Ben Scheirman on 6/23/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import Cocoa

class ViewController : NSViewController {
    
    @IBOutlet var textView: NSTextView!
    @IBOutlet var goButton: NSButton!
    @IBOutlet var cancelButton: NSButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func goClicked(sender: AnyObject) {
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
    }
    
    func appendText(text: String) {
        textView.textStorage?.appendAttributedString(
            NSAttributedString(string: "\(text)\n"))
    }
}

