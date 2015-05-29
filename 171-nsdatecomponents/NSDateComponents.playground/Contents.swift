import Cocoa


let today = NSDate()
let tomorrow = NSDate(timeIntervalSinceNow: 60 * 60 * 24)
let tonight = NSDate(timeIntervalSinceNow: 60 * 60 * 10)

let comps = NSDateComponents()
comps.hour = 12
comps.minute = 54
comps.day = 3
comps.month = 5
comps.year = 2014

let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
calendar.timeZone = NSTimeZone(abbreviation: "CDT")!

let date = calendar.dateFromComponents(comps)
date


let flags = NSCalendarUnit.CalendarUnitMonth |
NSCalendarUnit.CalendarUnitWeekday |
NSCalendarUnit.CalendarUnitYear |
NSCalendarUnit.CalendarUnitDay |
NSCalendarUnit.CalendarUnitHour |
NSCalendarUnit.CalendarUnitMinute |
NSCalendarUnit.CalendarUnitSecond

let comps2 = calendar.components(flags, fromDate: today)
comps2.hour
comps2.minute
comps2.second
comps2.month
comps2.day
comps2.year
comps2.weekday
NSDateComponentUndefined


