//
//  MasterViewController.m
//  MantleDemo
//
//  Created by Ben Scheirman on 4/19/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "MasterViewController.h"
#import "Episode.h"

@interface MasterViewController ()

@property (nonatomic, strong) NSMutableArray *episodes;

@end

@implementation MasterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchEpisodes];
}

- (void)fetchEpisodes {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURL *episodesUrl = [NSURL URLWithString:@"https://www.nsscreencast.com/api/episodes.json"];
    NSURLSessionDataTask *task = [session dataTaskWithURL:episodesUrl
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                            if (httpResponse.statusCode == 200) {
                                                [self parseEpisodeJSONData:data];
                                            } else {
                                                NSLog(@"ERROR: %@", error);
                                            }
                                        }];
    [task resume];
}

- (void)parseEpisodeJSONData:(NSData *)data {
    NSArray *episodesJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"Episode JSON: %@", episodesJSON);
    
    self.episodes = [NSMutableArray array];
    for (NSDictionary *episodeJSON in episodesJSON) {
        NSError *error;
        Episode *episode = [MTLJSONAdapter modelOfClass:[Episode class]
                                     fromJSONDictionary:episodeJSON[@"episode"]
                                                  error:&error];
        if (episode) {
            NSLog(@"Episode: %@", episode);
            [self.episodes addObject:episode];
        } else {
            NSLog(@"ERROR: %@", error);
        }
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.episodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    Episode *episode = self.episodes[indexPath.row];
    cell.textLabel.text = episode.title;
    cell.detailTextLabel.text = episode.episodeDescription;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

@end
