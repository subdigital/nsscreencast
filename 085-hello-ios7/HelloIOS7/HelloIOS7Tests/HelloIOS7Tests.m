//
//  HelloIOS7Tests.m
//  HelloIOS7Tests
//
//  Created by ben on 9/14/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HelloIOS7Tests : XCTestCase

@end

@implementation HelloIOS7Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTAssertEqual(1, 2-1, @"Math is hard");
}

@end
