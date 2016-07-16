//: Playground - noun: a place where people can play

import Foundation


let times = [ 6 ]

let secondsInADay = 60 * 60 * 24
let oneWeek = secondsInADay * 7 // bad

let date = NSDate()

let calendar = NSCalendar.currentCalendar()
calendar.calendarIdentifier

let nextWeek = calendar.dateByAddingUnit(.Day, value: 7, toDate: date, options: [])


let units: NSCalendarUnit = [.Year, .Month, .Day, .Hour, .Minute, .Second]
let dateComponents = calendar.components(units, fromDate: date)

dateComponents.year
dateComponents.month
dateComponents.day
dateComponents.hour

let nextHour = times.filter { $0 > dateComponents.hour }.first
if let nextHour = nextHour {
    dateComponents.hour = nextHour
} else {
    dateComponents.day + 1
    dateComponents.hour = times.first! // + 24
}

dateComponents.minute = 0
dateComponents.second = 0
dateComponents.calendar = calendar

dateComponents.date

calendar.nextDateAfterDate(date, matchingHour: 5, minute: 30, second: 0, options: .MatchNextTime)

