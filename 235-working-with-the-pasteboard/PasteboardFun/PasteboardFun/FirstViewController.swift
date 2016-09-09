//
//  FirstViewController.swift
//  PasteboardFun
//
//  Created by Ben Scheirman on 9/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit
import MobileCoreServices

class FirstViewController: UIViewController {
    
    @IBOutlet weak var stringLabel: UILabel!
    @IBAction func copyString(sender: AnyObject) {
        
        
        let rtfData = try! stringLabel.attributedText!.dataFromRange(NSMakeRange(0, stringLabel.attributedText!.length),
                                                                documentAttributes: [ NSDocumentTypeDocumentAttribute:
                                                                    NSRTFTextDocumentType])
        
        UIPasteboard.generalPasteboard().items = [
            
            [ kUTTypePlainText as String : stringLabel.text! ],
            
            [ kUTTypeRTF as String : rtfData ]
            
        ]
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func copyImage(sender: AnyObject) {
        
        let image = imageView.image!
        if let data = UIImagePNGRepresentation(image) {
            UIPasteboard.generalPasteboard().setData(data,
                                                     forPasteboardType: kUTTypePNG as String)
        }
    }
    
    @IBOutlet weak var pasteContentView: UIView!
    @IBAction func pasteContent(sender: AnyObject) {
        pasteContentView.subviews.forEach { $0.removeFromSuperview() }
        
    
        let pasteboard = UIPasteboard.generalPasteboard()
        
        let imageTypes = UIPasteboardTypeListImage as! [String]
        
        if pasteboard.containsPasteboardTypes([kUTTypeRTF as String], inItemSet: nil) {
            
            if let data = pasteboard.dataForPasteboardType(kUTTypeRTF as String, inItemSet: nil)?.first as? NSData {
                let attributedString = try! NSAttributedString(data: data, options: [:], documentAttributes: nil)
                buildPasteLabel().attributedText = attributedString
            }
            
        } else if pasteboard.containsPasteboardTypes([kUTTypePlainText as String], inItemSet: nil) {
            
            let string = pasteboard.valuesForPasteboardType(kUTTypePlainText as String, inItemSet: nil)?.first! as! String
            buildPasteLabel().text = string
            
        } else if pasteboard.containsPasteboardTypes(imageTypes) {
            for imageType in imageTypes {
                if let data = pasteboard.dataForPasteboardType(imageType) {
                    if let image = UIImage(data: data) {
                        buildPasteImageView().image = image
                        break
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

 
    
    func buildPasteLabel() -> UILabel {
        let label = UILabel(frame: CGRectMake(0, 0, 250, 100))
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        label.backgroundColor = .whiteColor()
        pasteContentView.addSubview(label)
        label.center = CGPointMake(pasteContentView.frame.size.width / 2.0, pasteContentView.frame.size.height / 2.0)
        return label
    }
    
    func buildPasteImageView() -> UIImageView {
        let imageView = UIImageView(frame: pasteContentView.bounds)
        imageView.contentMode = .Center
        pasteContentView.addSubview(imageView)
        return imageView
    }
    
    
}

