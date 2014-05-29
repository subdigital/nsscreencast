//
//  SyncController.m
//  MantleDemo
//
//  Created by ben on 5/5/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "SyncController.h"
#import "Episode.h"

@interface SyncController ()

@property (nonatomic, strong) MDMPersistenceController *persistenceController;

@end

@implementation SyncController

- (instancetype)initWithPersistenceController:(MDMPersistenceController *)persistenceController {
    self = [super init];
    if (self) {
        self.persistenceController = persistenceController;
    }
    return self;
}

- (void)syncEpisodes {
    NSAssert(self.persistenceController != nil, @"Must initialize with -initWithPersistenceController:");
    [self fetchEpisodesWithCompletion:^(NSArray *episodes) {
        NSManagedObjectContext *moc = [self.persistenceController newChildManagedObjectContext];
        [episodes enumerateObjectsUsingBlock:^(Episode *episode, NSUInteger idx, BOOL *stop) {
            NSError *insertError;
            NSManagedObject *mob = [MTLManagedObjectAdapter managedObjectFromModel:episode
                                                              insertingIntoContext:moc
                                                                             error:&insertError];
//            if ([[mob valueForKey:@"episodeNumber"] isEqual:@(115)]) {
//                if (![[mob valueForKey:@"title"] isEqualToString:@"asdf"]) {
//                    [mob setValue:@"asdf" forKey:@"title"];
//                    [mob setValue:[NSDate date] forKey:@"publishedAt"];
//                }
//            }
            
            if (mob) {
                NSLog(@"Mob: %@", mob);
            } else {
                NSLog(@"ERROR: %@", insertError);
                abort();
            }
        }];
        
        NSError *saveError;
        if ([moc save:&saveError]) {
            [self.persistenceController saveContextAndWait:YES completion:^(NSError *error) {
                NSLog(@"Save completed (%@)", error);
            }];
        } else {
            NSLog(@"Error saving: %@", saveError);
        }
    }];
}

- (void)fetchEpisodesWithCompletion:(void (^)(NSArray *episodes))completion {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURL *episodesUrl = [NSURL URLWithString:@"https://www.nsscreencast.com/api/episodes.json"];
    NSURLSessionDataTask *task = [session dataTaskWithURL:episodesUrl
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                            if (httpResponse.statusCode == 200) {
                                                NSArray *episodes = [self parseEpisodeJSONData:data];
                                                completion(episodes);
                                            } else {
                                                NSLog(@"ERROR: %@", error);
                                            }
                                        }];
    [task resume];
}

- (NSArray *)parseEpisodeJSONData:(NSData *)data {
    NSArray *episodesJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"Episode JSON: %@", episodesJSON);
    
    NSMutableArray *episodes = [NSMutableArray array];
    for (NSDictionary *episodeJSON in episodesJSON) {
        NSError *error;
        id attributes = episodeJSON[@"episode"];
        Episode *episode = [MTLJSONAdapter modelOfClass:[Episode class]
                                     fromJSONDictionary:attributes
                                                  error:&error];
        
        if (episode) {
            [episodes addObject:episode];
        } else {
            NSLog(@"ERROR parsing JSON: %@", error);
            abort();
        }
    }
    return episodes;
}

@end
