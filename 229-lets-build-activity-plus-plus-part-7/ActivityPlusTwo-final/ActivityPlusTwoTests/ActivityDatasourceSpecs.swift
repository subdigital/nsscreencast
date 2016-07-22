//
//  ActivityDatasourceSpecs.swift
//  ActivityPlusTwo
//
//  Created by Ben Scheirman on 7/12/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Quick
import Nimble
@testable import ActivityPlusTwo

class ActivityDatasourceSpecs : QuickSpec {
    override func spec() {
     
        let calendar = NSCalendar.currentCalendar()
        var samples: [ActivityLog]!
        var streaks: [Streak]!
        
        describe("streak detection") { 
            
            context("no streaks") {
                beforeEach {
                    samples = FakeHealthData.randomSamplesWithNoStreaks(calendar: calendar, startingWithDate: NSDate())
                    var datasource = ActivityDataSource(calendar: calendar, activities: samples)
                    streaks = datasource.streaks
                }
                
                it("should return an empty array") {
                    expect(streaks).to(beEmpty())
                }
            }
            
            context("with known streaks") {
                beforeEach {
                    samples = FakeHealthData.randomSampleWithStreaks(
                        calendar: calendar,
                        startingWithDate: NSDate())
                    var datasource = ActivityDataSource(calendar: calendar, activities: samples)
                    streaks = datasource.streaks
                }
                
                it("should return 2 streaks") {
                    expect(streaks).to(haveCount(2))
                }
                
                it("should return a 4-day streak of movement") {
                    
                    let movementStreak = streaks.filter { $0.metricType == .Movement }.first
                    expect(movementStreak).toNot(beNil())
                    expect(movementStreak!.numberOfDays).to(equal(4))
                }
                
                it("should return a 5-day streak of standing") {
                    let standingStreak = streaks.filter { $0.metricType == .Standing }.first
                    expect(standingStreak).toNot(beNil())
                    expect(standingStreak!.numberOfDays).to(equal(5))

                }
            }
            
            
        }
        
        
        
    }
}
