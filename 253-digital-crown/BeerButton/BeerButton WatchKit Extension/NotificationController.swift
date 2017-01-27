//
//  NotificationController.swift
//  BeerButton
//
//  Created by Conrad Stoll on 4/11/16.
//  Copyright © 2016 Conrad Stoll. All rights reserved.
//

import Foundation
import UserNotifications
import WatchKit

class NotificationController : WKUserNotificationInterfaceController {
    
    @IBOutlet weak var label : WKInterfaceLabel?
    @IBOutlet weak var timer : WKInterfaceTimer?
    @IBOutlet weak var image : WKInterfaceImage?
    
    override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Swift.Void) {
        let request = notification.request
        let content = request.content
        let userInfo = content.userInfo
        
        let order = Order.orderNotification(userInfo)
        let time = order.date.timeIntervalSinceNow
        
        self.label?.setText(order.title)
        
        self.image?.setImage(order.image)
        
        self.timer?.setDate(order.date)
        self.timer?.start()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.timer?.setDate(Date())
            self.timer?.stop()
            
            self.animate(withDuration: 0.5, animations: {
                self.label?.setText("Delivered!")
                self.timer?.setAlpha(0)
                self.timer?.setHidden(true)
            })
        }
        
        completionHandler(.custom)
    }
}
