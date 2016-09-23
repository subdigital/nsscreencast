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
    @IBAction func copyString(_ sender: AnyObject) {
        
        
        let rtfData = try! stringLabel.attributedText!.data(from: NSMakeRange(0, stringLabel.attributedText!.length),
                                                                documentAttributes: [ NSDocumentTypeDocumentAttribute:
                                                                    NSRTFTextDocumentType])
        
        UIPasteboard.general.items = [
            
            [ kUTTypePlainText as String : stringLabel.text! ],
            
            [ kUTTypeRTF as String : rtfData ]
            
        ]
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func copyImage(_ sender: AnyObject) {
        
        let image = imageView.image!
        if let data = UIImagePNGRepresentation(image) {
            UIPasteboard.general.setData(data,
                                                     forPasteboardType: kUTTypePNG as String)
        }
    }
    
    @IBOutlet weak var pasteContentView: UIView!
    @IBAction func pasteContent(_ sender: AnyObject) {
        pasteContentView.subviews.forEach { $0.removeFromSuperview() }
        
    
        let pasteboard = UIPasteboard.general
        
        let imageTypes = UIPasteboardTypeListImage as! [String]
        
        if pasteboard.contains(pasteboardTypes: [kUTTypeRTF as String], inItemSet: nil) {
            
            if let data = pasteboard.data(forPasteboardType: kUTTypeRTF as String, inItemSet: nil)?.first as? Data {
                let attributedString = try! NSAttributedString(data: data, options: [:], documentAttributes: nil)
                buildPasteLabel().attributedText = attributedString
            }
            
        } else if pasteboard.contains(pasteboardTypes: [kUTTypePlainText as String], inItemSet: nil) {
            
            let string = pasteboard.values(forPasteboardType: kUTTypePlainText as String, inItemSet: nil)?.first! as! String
            buildPasteLabel().text = string
            
        } else if pasteboard.contains(pasteboardTypes: imageTypes) {
            for imageType in imageTypes {
                if let data = pasteboard.data(forPasteboardType: imageType) {
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
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 100))
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.backgroundColor = .white
        pasteContentView.addSubview(label)
        label.center = CGPoint(x: pasteContentView.frame.size.width / 2.0, y: pasteContentView.frame.size.height / 2.0)
        return label
    }
    
    func buildPasteImageView() -> UIImageView {
        let imageView = UIImageView(frame: pasteContentView.bounds)
        imageView.contentMode = .center
        pasteContentView.addSubview(imageView)
        return imageView
    }
    
    
}

