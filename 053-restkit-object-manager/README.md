## Episode Links

- [Episode Source Code](https://github.com/subdigital/nsscreencast/blob/master/053-restkit-object-manager)
- [RKObjectManager documentation](http://restkit.org/api/master/Classes/RKObjectManager.html)

## Our Data Model

For this example we will work with a simple domain model representing a wiki.

<pre lang="objc">
@interface WKCategory : NSObject

@property (nonatomic, copy) NSString *name;

@end

@interface WKWikiPage : NSObject

@property (nonatomic, assign) NSInteger pageID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) WKSlug *slug;
@property (nonatomic, strong) WKCategory *category;

@end

@interface WKSlug : NSObject

@property (nonatomic, copy) NSString *value;

@end

</pre>

With this model in place, we can create a simple test class to assert some behaviors.

## Testing Path Patterns

Using a path pattern, we can generate URLs for resources, easily substituting tokens in the pattern
with values from keypaths on our objects.

<pre lang="objc">
- (void)testPathBuilding {
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
</pre>

Here you can see that path segments are used as keypaths in the provided objects in order to
construct the desired URL.

## Testing Routes

`RKRoute` is a class that uses Path Patterns in order to dynamically figure out what URL to
use for a given HTTP request.

For this test we'll need to provide a hook to allow for intercepting the actual HTTP requests
so they are not sent, but also to add assertions on the request sent.

<pre lang="objc">
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
</pre>

Now that this is in place, we can use it instead of `RKObjectManager` when in our tests.  The requests
will be caught by this method and never sent to `super`.  We can now write our test:

<pre lang="objc">
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
                          success:^(RKObjectRequestOperation *operation,
                                    RKMappingResult *mappingResult) {
                          } failure:^(RKObjectRequestOperation *operation,
                                      NSError *error) {
                          }];

    STAssertEquals(1, (int)self.objectManager.enqueuedOperations.count, nil);
    RKObjectRequestOperation *op = [self.objectManager.enqueuedOperations objectAtIndex:0];

    NSURL *url = op.HTTPRequestOperation.request.URL;
    NSString *urlString = [url description];
    STAssertEqualObjects(@"http://api.example.com/v2/pages/15.json", urlString, nil);
}
</pre>

## Testing Request Descriptors

`RKRequestDescriptor` can be added to an `RKObjectManager` to automatically convert an object
to it's desired representation for a request.  For example if we wanted to create a new `WKWikiPage`
and save it on the server via an HTTP POST, we'd have to convert the page object
to a form-encoded or json structure for the request.

<pre lang="objc">
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
</pre>

