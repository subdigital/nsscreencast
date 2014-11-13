//
//  ImgurApi.m
//  ImgShare
//
//  Created by Ben Scheirman on 11/2/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "ImgurApi.h"
#import "NSArray+CollectionAdditions.h"

#define BASE_URL @"https://api.imgur.com/3/"

@interface ImgurApi () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfig;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *callbacks;
@property (nonatomic, strong) NSMutableDictionary *requestData;

@property (nonatomic, strong) NSURLSessionConfiguration *backgroundSessionConfig;
@property (nonatomic, strong) NSURLSession *backgroundSession;


@end

@implementation ImgurApi

+ (instancetype)sharedApi {
    static ImgurApi *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[ImgurApi alloc] init];
    });
    return __instance;
}

- (id)init {
    if (self = [super init]) {
        [self loadClientId];
        
        self.sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.sessionConfig.HTTPAdditionalHeaders = [self authorizationHeader];
        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfig];
        
        self.backgroundSessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.nsscreencast.ImgShare.BackgroundSession"];
        self.backgroundSessionConfig.sharedContainerIdentifier = @"group.com.nsscreencast.ImgShare";
        self.backgroundSession = [NSURLSession sessionWithConfiguration:self.backgroundSessionConfig
                                                               delegate:self
                                                          delegateQueue:[NSOperationQueue mainQueue]
                                  ];
        
        self.callbacks = [NSMutableDictionary dictionary];
        self.requestData = [NSMutableDictionary dictionary];
    }
    
    return self;
}


- (NSDictionary *)authorizationHeader {
    return @{ @"Authorization" : [NSString stringWithFormat:@"Client-ID %@", self.clientID] };
}

- (void)loadClientId {
    NSString *keysFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Keys" ofType:@"plist"];
    if (!keysFilePath ) {
        [[NSException exceptionWithName:@"APIConfigurationException"
                                 reason:@"Couldn't find Keys.plist.  Configure your keys using the Keys.example.plist file and run the application again."
                               userInfo:nil] raise];
    } else {
        NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:keysFilePath];
        self.clientID = keys[@"ImgurClientId"];
    }
}

- (NSURL *)URLForPath:(NSString *)path {
    NSURL *baseUrl = [NSURL URLWithString:BASE_URL];
    NSURL *url = [NSURL URLWithString:path relativeToURL:baseUrl];
    return url;
}

- (void)requestPath:(NSString *)path completion:(void (^)(id responseObject))completion {
    if (!self.clientID) {
        [[NSException exceptionWithName:@"Invalid Usage" reason:@"You must configure with a client id"
                              userInfo:nil] raise];
        return;
    }
    
    NSURL *url = [self URLForPath:path];
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url
                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                 if (error) {
                                                     NSLog(@"ERROR with request for %@: %@", url, error);
                                                     completion(nil);
                                                 } else {
                                                     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                     if (httpResponse.statusCode == 200) {
                                                         id json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                   options:NSJSONReadingAllowFragments
                                                                                                     error:nil];
                                                         completion(json);
                                                     } else {
                                                         NSLog(@"Received HTTP %d for %@", (int)httpResponse.statusCode, url);
                                                     }
                                                 }
                                             }];
    [task resume];
}

- (void)fetchGalleryWithCompletion:(void (^)(NSArray *images))completion {
    [[ImgurApi sharedApi] requestPath:@"gallery" completion:^(NSDictionary *pagedResponse) {
        NSArray *galleryImages = [pagedResponse[@"data"] img_select:^BOOL(NSDictionary *item) {
            return ![item[@"is_album"] boolValue];
        }];
        
        NSArray *imageUrls = [galleryImages img_map:(id) ^(NSDictionary *item) {
            return [NSURL URLWithString:item[@"link"]];
        }];

        completion(imageUrls);
    }];
}

- (void)uploadImageAtURL:(NSURL *)imageURL withTitle:(NSString *)title completion:(void (^)(BOOL success, NSError *error))completion {
    NSURL *url = [self URLForPath:@"image"];
    NSLog(@"Posting %@ to %@", imageURL, [url path]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.allHTTPHeaderFields = @{
                                     @"Authorization": [NSString stringWithFormat:@"Client-ID %@", self.clientID]
                                   };
    
    NSURLSessionUploadTask *upload = [self.backgroundSession uploadTaskWithRequest:request
                                                                          fromFile:imageURL];
    self.callbacks[upload] = [completion copy];
    [upload resume];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    void (^callback)(BOOL success, NSError *error) = self.callbacks[task];
    
    if (error) {
        callback(NO, error);
    } else {
        NSLog(@"Upload completed");
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"Status code: %d", (int)response.statusCode);
        NSData *responseData = self.requestData[task];
        NSString *responseString = [[NSString alloc] initWithData:responseData
                                                         encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@", responseString);
        
        if (response.statusCode == 200) {
            callback(YES, nil);
        } else {
            callback(NO, nil);
        }
    }
    
    [self.requestData removeObjectForKey:task];
    [self.callbacks removeObjectForKey:task];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (!self.requestData[dataTask]) {
        self.requestData[dataTask] = [NSMutableData data];
    }
    
    NSMutableData *taskData = self.requestData[dataTask];
    [taskData appendData:data];
}

@end
