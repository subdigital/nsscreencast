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
    
    let operationQueue = NSOperationQueue()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func goClicked(sender: AnyObject) {
        cancelButton.enabled = true
        goButton.enabled = false
        
        computeFreeSpaceFor("/")
        computeFreeSpaceFor("/Volumes/Mako")
    }
    
    func computeFreeSpaceFor(path: String) {
        let operation = FreeSpaceOperation(path: path)
        
        appendText("Computing free space for \(path) ...")
        operation.completionBlock = { [weak self] in
            dispatch_async(dispatch_get_main_queue()) {
                
                if operation.cancelled {
                    self?.appendText("Cancelled")
                } else {
                    
                    if let spaceFree = operation.fileSystemAttributes?[NSFileSystemFreeSize] as? NSNumber {
                        let spaceFreeBytes = spaceFree.longLongValue
                        let spaceFreeString = NSByteCountFormatter.stringFromByteCount(spaceFreeBytes,
                            countStyle: NSByteCountFormatterCountStyle.File)
                        
                        self?.appendText("Free space on \(operation.path): \(spaceFreeString)")
                    }
                }
                
                
                
                self?.cancelButton.enabled = false
                self?.goButton.enabled = true
            }
        }
        
        operationQueue.addOperation(operation)
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        operationQueue.cancelAllOperations()
    }
    
    func appendText(text: String) {
        textView.textStorage?.appendAttributedString(
            NSAttributedString(string: "\(text)\n"))
    }
}

