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

        describe("streak detection") {
            
            var samples: [ActivityLog]!
            let calendar = NSCalendar.currentCalendar()
            var streaks: [Streak]!

        
            context("no streaks") {
                beforeEach {
                    samples = FakeHealthData.randomSamplesWithNoStreaks(calendar: calendar, startingWithDate: NSDate())
                    var datasource = ActivityDataSource(calendar: calendar, activities: samples)
                    streaks = datasource.streaks
                }
                
                it("returns no streaks") {
                    expect(streaks).to(beEmpty())
                }
            }
            
            context("known streaks") {
                beforeEach {
                    samples = FakeHealthData.randomSampleWithStreaks(calendar: calendar, startingWithDate: NSDate())
                    var datasource = ActivityDataSource(calendar: calendar, activities: samples)
                    streaks = datasource.streaks
                }
                
                it("should return 2 streaks") {
                    expect(streaks).to(haveCount(2))
                }
                
                it("should have a movement streak of 4 days") {
                    let movementStreak = streaks.filter { $0.metric == .Movement }.first
                    expect(movementStreak).notTo(beNil())
                    expect(movementStreak!.numberOfDays).to(equal(4))
                }
                
                it("should have a standing streak of 5 days") {
                    let standingStreak = streaks.filter { $0.metric == .Standing }.first
                    expect(standingStreak).notTo(beNil())
                    expect(standingStreak!.numberOfDays).to(equal(5))
                }
            }
            
            
        }
        
    }
}
