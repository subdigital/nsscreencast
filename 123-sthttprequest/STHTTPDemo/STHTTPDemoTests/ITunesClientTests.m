//
//  STHTTPDemoTests.m
//  STHTTPDemoTests
//
//  Created by Ben Scheirman on 5/26/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ITunesClient.h"
#import "STHTTPRequest+UnitTests.h"
#import "STHTTPRequestTestResponse.h"
#import "STHTTPRequestTestResponseQueue.h"

@interface ITunesClientTests : XCTestCase

@property (nonatomic, strong) ITunesClient *client;

@end

@implementation ITunesClientTests

- (void)setUp {
    [super setUp];
    self.client = [[ITunesClient alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSearching {
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [testBundle pathForResource:@"searchResponse" ofType:@"json"];
    
    STHTTPRequestTestResponseQueue *queue = [STHTTPRequestTestResponseQueue sharedInstance];
    STHTTPRequestTestResponse *response = [STHTTPRequestTestResponse testResponseWithBlock:^(STHTTPRequest *r) {
        r.responseHeaders = @{};
        r.responseStatus = 200;
        r.responseData = [NSData dataWithContentsOfFile:path];
    }];
    
    [queue enqueue:response];
    
    __block BOOL blockCalled;
    [self.client search:@"Breaking" completion:^(NSArray *results, NSError *error) {
        XCTAssertEqual(50, results.count, @"Expected 50 objects");
        blockCalled = YES;
    }];
    
    XCTAssertTrue(blockCalled, @"block was never called");
}

@end
