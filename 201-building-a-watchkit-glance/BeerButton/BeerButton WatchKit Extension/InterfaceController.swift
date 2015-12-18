//
//  InterfaceController.swift
//  BeerButton WatchKit Extension
//
//  Created by Conrad Stoll on 11/1/15.
//  Copyright © 2015 Conrad Stoll. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import ClockKit

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var picker : WKInterfacePicker?
    @IBOutlet weak var button : WKInterfaceButton?
    @IBOutlet weak var group : WKInterfaceGroup?
    
    var beers : [Beer] = []
    var currentBeer : Beer?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        let session = WCSession.defaultSession()
        session.delegate = self
        session.activateSession()
    }

    override func willActivate() {
        super.willActivate()
       
    }

    override func didDeactivate() {
        super.didDeactivate()
        
    }
    
    func updatePickerItems() {
        var items : [WKPickerItem] = []
        
        for beer in beers {
            let item = WKPickerItem()
            item.title = beer.title
            
            if let image = beer.image {
                item.contentImage = WKImage(image: image)
            }
            
            items.append(item)
        }
        
        self.picker?.setItems(items)
        self.pickerDidChange(0)
    }
    
    func didOrderBeer() {
        if let beer = currentBeer {
            let deliveryDate = NSDate(timeIntervalSinceNow: 120)

            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(["title" : beer.title, "date" : deliveryDate, "beer" : beer.toDictionary()], forKey:  "order")
            defaults.setObject(UIImagePNGRepresentation((beer.image?.squareImageTo(CGSizeMake(22,22)))!), forKey: "imageData")
            
            let complicationServer = CLKComplicationServer.sharedInstance()
            
            for complication in complicationServer.activeComplications {
                complicationServer.reloadTimelineForComplication(complication)
            }
            
            self.animateWithDuration(0.5, animations: {
                self.group?.setHeight(40)
                self.group?.setWidth(40)
                self.group?.setCornerRadius(20)
                self.button?.setAlpha(0)
            })
            
            self.button?.setEnabled(false)
        }
    }
    
    @IBAction func didTapButton(sender: AnyObject?) {
        didOrderBeer()
    }
    
    @IBAction func pickerDidChange(index: Int) {
        let beer = beers[index]
        currentBeer = beer
        
        self.button?.setTitle(currentBeer?.title)
        
        if let image = currentBeer?.image {
            self.group?.setBackgroundImage(image)
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        if let array = applicationContext["beers"] as? [[String : AnyObject]] {
            beers.removeAll()
            
            for item in array {
                let beer = Beer(dictionary: item)
                beers.append(beer)
            }
            
            self.updatePickerItems()
        }
    }
}
