//
//  BLLatte.m
//  BestLatte
//
//  Created by Ben Scheirman on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BLLatte.h"
#import "AFNetworking.h"
#import "BlocksKit.h"
#import "BLAPIClient.h"
#import "BLNotifications.h"
#import "NSDictionary+JSONValueParsing.h"

@implementation BLLatte

@synthesize serverId, location, thumbnailUrl, largeUrl, comments, submittedBy, photoData;

+ (void)fetchLattes:(void (^)(NSArray *lattes, NSError *error))completionBlock {
    [[BLAPIClient sharedClient] getPath:@"/lattes.json" parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    if (operation.response.statusCode == 200) {
                                        NSArray *lattes = [BLLatte lattesWithJSON:responseObject];
                                        completionBlock(lattes, nil);
                                    } else {
                                        NSLog(@"Received an HTTP %d: %@", operation.response.statusCode, responseObject);
                                        completionBlock(nil, nil);
                                    }                                   
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    completionBlock(nil, error);                                    
                                }];
}

+ (NSArray *)lattesWithJSON:(NSArray *)lattesJson {
    return [lattesJson map:^id(id itemJson) {
        return [BLLatte latteFromJSON:itemJson];
    }];
}

+ (BLLatte *)latteFromJSON:(NSDictionary *)dictionary {
    BLLatte *latte = [[BLLatte alloc] init];
    [latte updateFromJSON:dictionary];
        
    return latte;
}

- (void)updateFromJSON:(NSDictionary *)dictionary {
    self.serverId = [dictionary intForKey:@"id"];
    self.location = [dictionary stringForKey:@"location"];
    self.submittedBy = [dictionary stringForKey:@"submitted_by"];
    self.comments = [dictionary stringForKey:@"comments"];
    
    NSDictionary *photoDictionary = [dictionary objectForKey:@"photo"];
    self.largeUrl = [photoDictionary stringForKey:@"url"];
    
    NSString *photoKey = IsRetina() ? @"thumb_retina" : @"thumb";
    NSDictionary *thumbDictionary = [photoDictionary objectForKey:photoKey];
    self.thumbnailUrl = [thumbDictionary stringForKey:@"url"];
}

- (void)saveWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock {
    [self saveWithProgress:nil completion:completionBlock];
}

- (void)saveWithProgress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock {

    //make sure none of the parameters are nil, otherwise it will mess up our dictionary
    if (!self.location) self.location = @"";
    if (!self.submittedBy) self.submittedBy = @"";
    if (!self.comments) self.comments = @"";

    NSDictionary *params = @{
    @"latte[location]" : self.location,
    @"latte[submitted_by]" : self.submittedBy,
    @"latte[comments]" : self.comments
    };
    
    NSURLRequest *postRequest = [[BLAPIClient sharedClient] multipartFormRequestWithMethod:@"POST"
                                                                                      path:@"/lattes"
                                                                                parameters:params
                                                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                        [formData appendPartWithFileData:self.photoData
                                                                                                    name:@"latte[photo]"
                                                                                                fileName:@"latte.png"
                                                                                                mimeType:@"image/png"];
                                                                 }];
    
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:postRequest];
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat progress = ((CGFloat)totalBytesWritten) / totalBytesExpectedToWrite;
        progressBlock(progress);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            NSLog(@"Created, %@", responseObject);
            NSDictionary *updatedLatte = [responseObject objectForKey:@"latte"];
            [self updateFromJSON:updatedLatte];
            [self notifyCreated];
            completionBlock(YES, nil);
        } else {
            completionBlock(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(NO, error);
    }];
    
    [[BLAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
};

- (void)notifyCreated {
    [[NSNotificationCenter defaultCenter] postNotificationName:BLLatteCreatedNotification
                                                        object:self];
}

@end
