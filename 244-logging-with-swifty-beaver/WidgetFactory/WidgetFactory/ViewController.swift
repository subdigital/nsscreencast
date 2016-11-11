//
//  ViewController.swift
//  WidgetFactory
//
//  Created by Ben Scheirman on 11/6/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import UIKit

enum WidgetType : String {
    case Sparkplug
    case HexagonalPortKey
    case IridiumWasher
}

class ViewController: UIViewController {
    
    let networkClient = NetworkClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkClient.get(url: URL(string: "http://example.com/ping")!)

        for i in 1...1000 {
            log.info("Creating widget \(i)...")
            createWidget()
        }
        
        networkClient.post(url: URL(string: "http://example.com/widget_activity")!, params: ["widgets_created": 1000])
    }

    func createWidget() {
        if randomError() {
            log.error("Error producing widget!")
        } else {
            let widget = ["Widget": [
                "Type": randomType(),
                "Serial Number:": serialNumber()
                ]
            ]
            log.debug("Widget: \(widget)")
        }
    }

    func serialNumber() -> String {
        return "\(arc4random_uniform(9999))-\(arc4random_uniform(9999))-\(arc4random_uniform(9999))"
    }

    func randomError() -> Bool {
        return arc4random_uniform(27) == 1
    }

    func randomType() -> String {
        switch arc4random_uniform(3) {
        case 1: return "Sparkplug"
        case 2: return "Hexagonal Port Key"
        default: return "Iridium Washer"
        }
    }
}

