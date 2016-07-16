//
//  NSScreencastApiClientTests.swift
//  nsscreencast-tvdemo
//
//  Created by Ben Scheirman on 1/11/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation
import XCTest
@testable import nsscreencast_tvdemo

class NSScreencastApiClientTests : XCTestCase {
    var apiClient: NSScreencastApiClient!
    
    override func setUp() {
        apiClient = NSScreencastApiClient.sharedApiClient
        apiClient.loggingEnabled = true
    }
    
    func testFetchSingleEpisode() {
        let expectation = expectationWithDescription("api  response received")
        apiClient.fetchEpisode(1) { result in
            expectation.fulfill()
            
            switch result {
            case .Success(let episode):
                XCTAssertEqual(1, episode.episodeId)
                XCTAssertEqual(1, episode.number)
                break
            default:
                XCTFail()
            }
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
}