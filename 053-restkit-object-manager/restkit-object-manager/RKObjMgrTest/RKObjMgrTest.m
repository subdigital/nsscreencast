//
//  RKObjMgrTest.m
//  RKObjMgrTest
//
//  Created by ben on 2/3/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import "WKWikiPage.h"
#import "WKSlug.h"
#import "WKCategory.h"

@interface TestObjectManager : RKObjectManager
@property (nonatomic, strong) NSMutableArray *enqueuedOperations;
@end

@implementation TestObjectManager

- (void)enqueueObjectRequestOperation:(RKObjectRequestOperation *)objectRequestOperation {
    if (!self.enqueuedOperations) {
        self.enqueuedOperations = [NSMutableArray array];
    }
    
    [self.enqueuedOperations addObject:objectRequestOperation];
}

@end

@interface RKObjMgrTest : SenTestCase

@property (nonatomic, strong) TestObjectManager *objectManager;
@end

@implementation RKObjMgrTest

- (void)setUp {
    [super setUp];
    
    NSURL *baseURL = [NSURL URLWithString:@"http://api.example.com/v2"];
    self.objectManager = [TestObjectManager managerWithBaseURL:baseURL];
}

- (void)tearDown {
    self.objectManager = nil;
    [super tearDown];
}

- (void)testPathBuilding {
    // pages/15/my-new-page
    // wiki/(category)/pages/(id)/(slug)  ==> pageID
    WKWikiPage *page = [[WKWikiPage alloc] init];
    page.pageID = 15;
    page.slug = [[WKSlug alloc] init];
    page.slug.value = @"my-new-page";
    
    page.category = [[WKCategory alloc] init];
    page.category.name = @"RestKit";
    
    NSString *path = RKPathFromPatternWithObject(@"/wiki/:category.name/:pageID/:slug.value\\.html", page);
    NSLog(@"PATH: %@", path);
    
    STAssertEqualObjects(@"/wiki/RestKit/15/my-new-page.html", path, nil);
}

- (void)testRouting {
    RKRoute *route = [RKRoute routeWithClass:[WKWikiPage class]
                                 pathPattern:@"pages/:pageID\\.json"
                                      method:RKRequestMethodAny];
    [self.objectManager.router.routeSet addRoute:route];

    WKWikiPage *page = [[WKWikiPage alloc] init];
    page.pageID = 15;
    
    [self.objectManager getObject:page
                             path:nil
                       parameters:nil
                          success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          }];
    
    STAssertEquals(1, (int)self.objectManager.enqueuedOperations.count, nil);
    RKObjectRequestOperation *op = [self.objectManager.enqueuedOperations objectAtIndex:0];
    
    NSURL *url = op.HTTPRequestOperation.request.URL;
    NSString *urlString = [url description];
    STAssertEqualObjects(@"http://api.example.com/v2/pages/15.json", urlString, nil);
}

- (void)testRequestDescriptor {
    RKRoute *route = [RKRoute routeWithClass:[WKWikiPage class]
                                 pathPattern:@"pages/:pageID\\.json"
                                      method:RKRequestMethodAny];
    [self.objectManager.router.routeSet addRoute:route];
    
    WKWikiPage *page = [[WKWikiPage alloc] init];
    page.pageID = 15;
    page.slug = [[WKSlug alloc] init];
    page.slug.value = @"my-new-page";
    page.title = @"This is my new page";
    page.body = @"This is the body";
    
    page.category = [[WKCategory alloc] init];
    page.category.name = @"RestKit";
    
    RKObjectMapping *categoryRequestMapping = [RKObjectMapping requestMapping];
    [categoryRequestMapping addAttributeMappingsFromArray:@[@"name"]];
    
    RKObjectMapping *reqMapping = [RKObjectMapping requestMapping];
    [reqMapping addAttributeMappingsFromArray:@[@"title", @"body"]];
    [reqMapping addAttributeMappingsFromDictionary:@{@"slug.value": @"slug"}];
    [reqMapping addRelationshipMappingWithSourceKeyPath:@"category"
                                                mapping:categoryRequestMapping];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:reqMapping
                                                                                   objectClass:[WKWikiPage class]
                                                                                   rootKeyPath:@"page"];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    self.objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    [self.objectManager postObject:page
                              path:nil
                        parameters:nil
                           success:nil
                           failure:nil];
    
    STAssertEquals(1, (int)self.objectManager.enqueuedOperations.count, nil);
    RKObjectRequestOperation *op = [self.objectManager.enqueuedOperations objectAtIndex:0];
    NSData *data = op.HTTPRequestOperation.request.HTTPBody;
    NSString *json = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
    NSLog(@"BODY: %@", json);
}

@end



