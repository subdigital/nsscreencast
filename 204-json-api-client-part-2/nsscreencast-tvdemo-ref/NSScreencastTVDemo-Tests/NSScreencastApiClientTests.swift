//
//  NSScreencastApiClientTests.swift
//  nsscreencast-tvdemo
//
//  Created by Ben Scheirman on 1/10/16.
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
    
    override func tearDown() {
    }
    
    func testFetchSingleEpisode() {
        let expectation = expectationWithDescription("Api response received")
        apiClient.fetchEpisode(1) { result in
            expectation.fulfill()
            switch result {
            case .Success(let episode):
                
                XCTAssertEqual(episode.episodeId, 1)
                XCTAssertEqual(episode.number, 1)
                
                break
            default:
                XCTFail("Expected success but was \(result)")
            }
        }
        
        waitForExpectationsWithTimeout(3, handler: nil)
    }
}