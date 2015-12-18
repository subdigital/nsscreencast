//
//  GlanceController.swift
//  BeerButton WatchKit Extension
//
//  Created by Conrad Stoll on 11/1/15.
//  Copyright © 2015 Conrad Stoll. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {
    
    @IBOutlet weak var image : WKInterfaceImage?
    @IBOutlet weak var timer : WKInterfaceTimer?
    @IBOutlet weak var label : WKInterfaceLabel?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
    }

    override func willActivate() {
        super.willActivate()
    
        checkForCurrentOrders()
    }

    override func didDeactivate() {
        super.didDeactivate()
        
    }
    
    func checkForCurrentOrders() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var title : String?
        var date : NSDate?
        var beer : Beer?
        
        if let order = defaults.objectForKey("order") as? [String : AnyObject] {
            title = order["title"] as? String
            date = order["date"] as? NSDate
            
            if let beerObject = order["beer"] as? [String : AnyObject] {
                beer = Beer(dictionary: beerObject)
            }
            
            if let orderDate = date {
                self.timer?.setDate(orderDate)
            }
            
            if let orderTitle = title {
                self.label?.setText(orderTitle)
            }
            
            self.timer?.start()
            self.image?.setImage(beer?.image)
        }
    }
}








