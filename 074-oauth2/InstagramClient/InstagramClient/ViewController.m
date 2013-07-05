//
//  ViewController.m
//  InstagramClient
//
//  Created by ben on 6/30/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#define INSTAGRAM_CLIENT_ID @"1f074f314d1347789cc9d9a9d19ee342"


#import "ViewController.h"
#import "InstagramClient.h"
#import "ImageCell.h"

@interface ViewController ()
@property (nonatomic, strong) NSDictionary *timelineResponse;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[ImageCell class]
            forCellWithReuseIdentifier:@"imageCell"];
    
    [self authenticateWithInstagram];
}

- (void)authenticateWithInstagram {
    NSString *callbackUrl = @"nsscreencast://instagram_callback";

    [[InstagramClient sharedClient] authenticateWithClientID:INSTAGRAM_CLIENT_ID callbackURL:callbackUrl];
}

- (IBAction)fetchTimeline:(id)sender {
    [[InstagramClient sharedClient] getPath:@"users/self/feed"
                                 parameters:nil
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSLog(@"Response: %@", responseObject);
                                        self.timelineResponse = responseObject;
                                        [self.collectionView reloadData];
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        NSLog(@"Failure: %@", error);
                                    }];
}

- (NSArray *)entries {
    return self.timelineResponse[@"data"];
}

- (NSURL *)imageUrlForEntryAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *entry = [self entries][indexPath.row];
    NSString *imageUrlString = entry[@"images"][@"low_resolution"][@"url"];
    return [NSURL URLWithString:imageUrlString];
}

#pragma mark - UICollectionViewDelegate


#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self entries] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = (ImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell"
                                                                             forIndexPath:indexPath];
    NSURL *url = [self imageUrlForEntryAtIndexPath:indexPath];
    NSLog(@"%@", url);
    [cell.imageView setImageWithURL:url];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

@end
