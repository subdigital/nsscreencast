//
//  ComplicationController.swift
//  BeerButton WatchKit Extension
//
//  Created by Conrad Stoll on 11/1/15.
//  Copyright © 2015 Conrad Stoll. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var title : String?
        var date : NSDate?
        
        if let order = defaults.objectForKey("order") as? [String : AnyObject] {
            title = order["title"] as? String
            date = order["date"] as? NSDate
        }
        
        if let orderTitle = title, orderDate = date {
            let entry = CLKComplicationTimelineEntry()
            let template = CLKComplicationTemplateModularLargeStandardBody()
            
            let headerTextProvider = CLKSimpleTextProvider(text: "Order Status")
            template.headerTextProvider = headerTextProvider
            
            let titleTextProvider = CLKSimpleTextProvider(text: orderTitle)
            template.body1TextProvider = titleTextProvider
            
            let timeTextProvider = CLKRelativeDateTextProvider(date: orderDate, style: .Timer, units: .Second)
            template.body2TextProvider = timeTextProvider
            
            entry.complicationTemplate = template
            entry.date = NSDate()
            
            handler(entry)
        } else {
            handler(nil)
        }
    }
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        handler(nil);
    }
    
    
    // MARK: - Default Method Implementations

    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.None])
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        handler(nil)
    }
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        if complication.family == .ModularLarge {
            let template = CLKComplicationTemplateModularLargeStandardBody()
            
            let headerTextProvider = CLKSimpleTextProvider(text: "Order Status")
            template.headerTextProvider = headerTextProvider
            
            let titleTextProvider = CLKSimpleTextProvider(text: "Pumpkin")
            template.body1TextProvider = titleTextProvider
            
            let timeTextProvider = CLKRelativeDateTextProvider(date: NSDate(timeIntervalSinceNow: 118), style: .Timer, units: .Second)
            template.body2TextProvider = timeTextProvider
            
            handler(template)
        } else {
            handler(nil)
        }
    }
}
