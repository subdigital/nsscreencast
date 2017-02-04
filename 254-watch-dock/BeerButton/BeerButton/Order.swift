//
//  Order.swift
//  BeerButton
//
//  Created by Conrad Stoll on 3/2/16.
//  Copyright © 2016 Conrad Stoll. All rights reserved.
//

import Foundation
import UIKit

struct Order {
    var title = ""
    var date : Date
    var beerDictionary : [String : Any]
    
    init(beer : Beer, deliveryDate : Date) {
        self.title = beer.title
        self.beerDictionary = beer.toDictionary()
        self.date = deliveryDate
    }
    
    func send() -> OrderNotification {
        let defaults = UserDefaults.standard
        defaults.set(["title" : self.title, "date" : date, "beer" : self.beerDictionary], forKey: "order")
        
        let title = "Your " + self.title + " will be delivered in"
        let beer = Beer(dictionary: beerDictionary)
        
        let notification = OrderNotification(title: title, date: date, image: beer.image!)
        
        return notification
    }
    
    static func currentOrder() -> Order? {
        let defaults = UserDefaults.standard
        
        if let order = defaults.object(forKey: "order") as? [String : AnyObject] {
            if let beerDictionary = order["beer"] as? [String : AnyObject] {
                let beer = Beer(dictionary: beerDictionary)
                let date = order["date"] as? Date
                
                if let orderDate = date {
                    if orderDate.timeIntervalSinceNow < Date().timeIntervalSinceNow {
                        clearOrder()
                        return nil
                    }
                    
                    let order = Order(beer: beer, deliveryDate: orderDate)
                    
                    return order
                }
            }
        }
        
        return nil
    }
    
    static func clearOrder() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "order")
    }
    
    static func orderNotificationDictionary(_ notification : OrderNotification) -> [String : Any] {
        let alert = ["body" : notification.title]
        let aps : [String : Any] = ["alert" : alert, "category" : "BeerButtonOrderDelivery"]
        
        let dictionary = ["aps" : aps, "deliveryDate" : notification.date, "beerImage" : UIImagePNGRepresentation(notification.image)!] as [String : Any]
        
        return dictionary
    }
    
    static func orderNotification(_ dictionary : [AnyHashable : Any]) -> OrderNotification {
        let aps = dictionary["aps"] as! [String : AnyObject]
        let title = aps["alert"]!["body"]! as! String
        let date = dictionary["deliveryDate"]! as! Date
        let image = UIImage(data: dictionary["beerImage"]! as! Data)!

        let notification = OrderNotification(title: title, date: date, image: image)
        
        return notification
    }
}

struct OrderNotification {
    let title : String
    let date : Date
    let image : UIImage
}

/*
 {
 "aps": {
    "alert": {
        "body": "Test message",
        "title": "Optional title"
    },
    "category": "BeerButtonOrderDelivery"
 },
 
 "WatchKit Simulator Actions": [
    {
        "title": "First Button",
        "identifier": "firstButtonAction"
    }
 ],
 
 "customKey": "Use this file to define a testing payload for your notifications. The aps dictionary specifies the category, alert text and title. The WatchKit Simulator Actions array can provide info for one or more action buttons in addition to the standard Dismiss button. Any other top level keys are custom payload. If you have multiple such JSON files in your project, you'll be able to select them when choosing to debug the notification interface of your Watch App."
 }
*/
