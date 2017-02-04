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
import UserNotifications

enum OrderStatus {
    case None
    case Ordered(Order, snapshot : Bool)
}

class InterfaceController: WKInterfaceController, WCSessionDelegate, WKCrownDelegate {
    
    @IBOutlet weak var group : WKInterfaceGroup?
    @IBOutlet weak var picker : WKInterfacePicker?
    @IBOutlet weak var button : WKInterfaceButton?
    @IBOutlet weak var beerTimer : WKInterfaceLabel?
    @IBOutlet weak var beerTitle : WKInterfaceLabel?
    
    var beers : [Beer] = []
    var currentBeer : Beer?
    var delivery : TimeInterval = 60 * 5
    
    var secondTimer : Timer?
    var snapshot : Bool = false
    
    var identifier : String?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    
        let session = WCSession.default()
        session.delegate = self
        session.activate()
        
        if let order = Order.currentOrder() {
            configureUI(status: .Ordered(order, snapshot: false))
            startTimer(forOrder: order)
        } else {
            configureUI(status: .None)
        }
        
        restoreCachedBeers()
        updateComplication()
        updatePickerItems()
        updateCrownSequencer()
    }
    
    // Lifecycle Methods

    override func willActivate() {
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        super.didDeactivate()

    }
    
    override func didAppear() {
        super.didAppear()
        
    }
    
    override func willDisappear() {
        super.willDisappear()
        
    }
    
    // Complication Methods
    
    func updateComplication() {
        let complicationServer = CLKComplicationServer.sharedInstance()
        
        for complication in complicationServer.activeComplications! {
            complicationServer.reloadTimeline(for: complication)
        }
    }
    
    // Picker Methods
    
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
        
        if (items.count > 0) {
            configureOrderingUI(withIndex: 0)
        }
    }
    
    @IBAction func pickerDidChange(_ index : Int) {
        configureOrderingUI(withIndex: index)
    }
    
    @IBAction func focusBeerPicker(gesture : WKTapGestureRecognizer) {
        self.picker?.focus()
    }
    
    // Crown Sequencer Methods
    
    func updateCrownSequencer() {
        self.crownSequencer.delegate = self
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        guard Order.currentOrder() == nil else {
            return
        }
        
        var delta = 1.0
        
        if let rps = crownSequencer?.rotationsPerSecond {
            if abs(rps) > 1.0 {
                delta = 15.0
            }
        }
        
        var newDelivery = delivery
        
        if rotationalDelta < 0 {
            newDelivery = delivery - delta
        } else if rotationalDelta > 0 {
            newDelivery = delivery + delta
        }
        
        if newDelivery > 0 {
            if delta > 1 {
                if rotationalDelta < 0 {
                    newDelivery = newDelivery - newDelivery.remainder(dividingBy: delta)
                } else {
                    newDelivery = newDelivery - newDelivery.truncatingRemainder(dividingBy: delta)
                }
            }
            
            delivery = newDelivery
        } else {
            delivery = 0
        }
        
        self.updateBeerTimer(withTimeInterval: delivery)
    }
    
    @IBAction func focusDatePicker(gesture : WKTapGestureRecognizer) {
        self.crownSequencer.focus()
    }
    
    // Ordering Methods
    
    @IBAction func didOrderBeer(_ sender : WKInterfaceButton) {
        let date = Date(timeIntervalSinceNow: delivery)
        
        if let beer = self.currentBeer {
            let order = Order(beer: beer, deliveryDate: date)
            
            let notification = order.send()
            let message = Order.orderNotificationDictionary(notification)
            notifyUser(message)
            
            self.animate(withDuration: 0.5, animations: {
                self.configureUI(status: .Ordered(order, snapshot: false))
            })
            
            startTimer(forOrder: order)
        }
        
        scheduleSnapshotRefresh(forDate: date)
        updateComplication()
    }
    
    // Notification Methods
    
    func notifyUser(_ message : [String : Any]) {
        let orderInfo = Order.orderNotification(message)
        
        let content = UNMutableNotificationContent()
        content.title = "Beer Delivery"
        content.body = orderInfo.title
        content.userInfo = message
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "BeerButtonOrderDelivery"
        content.subtitle = "subtitle"
        
        let time = orderInfo.date.timeIntervalSinceNow - 20.0
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        
        let uniqueIdentifier = self.stringWithUUID()
        
        let request = UNNotificationRequest(identifier: uniqueIdentifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        self.identifier = uniqueIdentifier
        
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        
        center.add(request)
    }
    
    // UI Methods
    
    func configureOrderingUI(withIndex index: Int) {
        guard Order.currentOrder() == nil else {
            return
        }
        
        let beer = beers[index]
        currentBeer = beer
        
        self.group?.setBackgroundImage(beer.image)
        self.button?.setTitle(beer.title)
    }
    
    func configureUI(status: OrderStatus) {
        if case .Ordered(let order, let snapshot) = status {
            let size : CGFloat = 40
            
            self.group?.setHorizontalAlignment(.left)
            self.group?.setVerticalAlignment(.top)
            self.beerTimer?.setHorizontalAlignment(.left)
            self.beerTimer?.setVerticalAlignment(.top)
            self.beerTitle?.setHorizontalAlignment(.left)
            self.beerTitle?.setVerticalAlignment(.top)
            
            self.group?.setHeight(size)
            self.group?.setWidth(size)
            self.group?.setCornerRadius(size / 2)
            
            self.button?.setAlpha(0)
            self.beerTitle?.setAlpha(1)
            
            self.button?.setTitle("")
            self.beerTitle?.setText(order.title)
            
            let beer = Beer(dictionary: order.beerDictionary)
            self.group?.setBackgroundImage(beer.image)
            
            self.snapshot = snapshot
        } else {
            self.group?.setHorizontalAlignment(.center)
            self.group?.setVerticalAlignment(.center)
            self.beerTimer?.setHorizontalAlignment(.center)
            self.beerTimer?.setVerticalAlignment(.bottom)
            self.beerTitle?.setHorizontalAlignment(.center)
            self.beerTitle?.setVerticalAlignment(.bottom)
            
            self.group?.setHeight(100)
            self.group?.setWidth(100)
            self.group?.setCornerRadius(50)
            
            self.button?.setAlpha(1)
            self.beerTitle?.setAlpha(0)
            
            self.snapshot = false
            self.updateBeerTimer(withTimeInterval: delivery)
        }
    }
    
    // WatchConnectivity Methods
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let array = applicationContext["beers"] as? [[String : AnyObject]] {
            handleArrayOfBeers(array: array)
        }
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            let session = WCSession.default()
            session.sendMessage(["message" : "refreshRequest"], replyHandler: { (items : [String : Any]) in
                if let array = items["beers"] as? [[String : AnyObject]] {
                    self.handleArrayOfBeers(array: array)
                }
            }) { (_) in
                
            }
        }
    }
}

extension InterfaceController {
    
    // Order Methods
    
    @IBAction func resetOrder() {
        self.secondTimer?.invalidate()
        self.secondTimer = nil
        
        Order.clearOrder()
        configureUI(status: .None)
        updateComplication()
        updatePickerItems()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
    
    // Timer Methods
    
    func startTimer(forOrder order: Order) {
        self.secondTimer?.invalidate()
        self.secondTimer = nil
        
        self.secondTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (_) in
            let currentTime = Date().timeIntervalSinceNow
            let arrivalTime = order.date.timeIntervalSinceNow
            let remainingTime = arrivalTime - currentTime
            
            if remainingTime < 0 {
                self.resetOrder()
                self.secondTimer?.invalidate()
                self.secondTimer = nil
            } else {
                self.updateBeerTimer(withTimeInterval: remainingTime)
            }
        })
    }
    
    func updateBeerTimer(withTimeInterval timeInterval: TimeInterval) {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second, .nanosecond]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        guard let time = formatter.string(from: timeInterval) else {
            return
        }
        
        if snapshot {
            let largerTime = NSMutableAttributedString(string: time)
            largerTime.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 48), range: NSMakeRange(0, time.characters.count))
            self.beerTimer?.setAttributedText(largerTime)
        } else {
            self.beerTimer?.setText(time)
        }
    }
    
    func scheduleSnapshotRefresh(forDate date: Date) {
        WKExtension.shared().scheduleSnapshotRefresh(withPreferredDate: date, userInfo: nil, scheduledCompletion: { error in
            
        })
    }
    
    // Notification Extensions
    
    // https://forums.developer.apple.com/message/149257
    func stringWithUUID() -> String {
        let uuidObj = CFUUIDCreate(nil)
        let uuidString = CFUUIDCreateString(nil, uuidObj)!
        return uuidString as String
    }
    
    // Beer Model Methods
    
    func restoreCachedBeers() {
        let defaults = UserDefaults.standard
        
        if let array = defaults.object(forKey: "beers") as? [[String : AnyObject]] {
            beers.removeAll()
            
            for item in array {
                let beer = Beer(dictionary: item)
                beers.append(beer)
            }
        }
    }
    
    func handleArrayOfBeers(array : [[String : AnyObject]]) {
        beers.removeAll()
        
        for item in array {
            let beer = Beer(dictionary: item)
            beers.append(beer)
        }
        
        self.updatePickerItems()
        self.updateCacheBeers()
    }
    
    func arrayOfBeerDictionaries() -> [[String : Any]] {
        var array : [[String : Any]] = []
        
        for item in beers {
            array.append(item.toDictionary())
        }
        
        return array
    }
    
    func updateCacheBeers() {
        let array = arrayOfBeerDictionaries()
        
        // Update Saved Cache
        let defaults = UserDefaults.standard
        defaults.set(array, forKey: "beers")
    }
}
