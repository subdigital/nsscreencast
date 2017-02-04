//
//  ComplicationController.swift
//  BeerButton WatchKit Extension
//
//  Created by Conrad Stoll on 11/1/15.
//  Copyright © 2015 Conrad Stoll. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {

    public func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        var title : String?
        var date : Date?
        
        if let order = Order.currentOrder() {
            title = order.title
            date = order.date as Date
        }
        
        if let orderTitle = title, let orderDate = date {
            let entry = CLKComplicationTimelineEntry()
            let template = CLKComplicationTemplateModularLargeStandardBody()
            
            let headerTextProvider = CLKSimpleTextProvider(text: "Order Status")
            template.headerTextProvider = headerTextProvider
            
            let titleTextProvider = CLKSimpleTextProvider(text: orderTitle)
            template.body1TextProvider = titleTextProvider
            
            let timeTextProvider = CLKRelativeDateTextProvider(date: orderDate, style: .timer, units: .second)
            template.body2TextProvider = timeTextProvider
            
            entry.complicationTemplate = template
            entry.date = Date()
            
            handler(entry)
        } else {
            let entry = CLKComplicationTimelineEntry()
            let template = CLKComplicationTemplateModularLargeStandardBody()
            
            let headerTextProvider = CLKSimpleTextProvider(text: "Beer Button")
            template.headerTextProvider = headerTextProvider
            
            let titleTextProvider = CLKSimpleTextProvider(text: "Place Order")
            template.body1TextProvider = titleTextProvider
            
            entry.complicationTemplate = template
            entry.date = Date()
            
            handler(entry)
        }
    }
    
    private func getNextRequestedUpdateDate(handler: (Date?) -> Swift.Void) {
        handler(nil)
    }
    
    // MARK: - Gallery Methods
    
    private func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
        let headerTextProvider = CLKSimpleTextProvider(text: "Beer Button")
        template.headerTextProvider = headerTextProvider
        
        let titleTextProvider = CLKSimpleTextProvider(text: "Place Order")
        template.body1TextProvider = titleTextProvider
        
        handler(template)
    }
    
    // MARK: - Default Method Implementations
    
    public func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Swift.Void) {
        handler(CLKComplicationTimeTravelDirections.forward)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping (([CLKComplicationTimelineEntry]?) -> Void)) {
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping (([CLKComplicationTimelineEntry]?) -> Void)) {
        if let order = Order.currentOrder() {
            let date = order.date as Date
            
            let entry = CLKComplicationTimelineEntry()
            let template = CLKComplicationTemplateModularLargeStandardBody()
            
            let headerTextProvider = CLKSimpleTextProvider(text: "Beer Button")
            template.headerTextProvider = headerTextProvider
            
            let titleTextProvider = CLKSimpleTextProvider(text: "Place Order")
            template.body1TextProvider = titleTextProvider
            
            entry.complicationTemplate = template
            entry.date = date
            
            handler([entry])
        } else {
            handler(nil)
        }
    }
}
