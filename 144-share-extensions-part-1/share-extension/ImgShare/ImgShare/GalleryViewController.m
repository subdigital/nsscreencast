//
//  ViewController.m
//  ImgShare
//
//  Created by Ben Scheirman on 11/1/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "GalleryViewController.h"
#import "ImageCell.h"
#import "UIImageView+AFNetworking.h"
@import ImgShareKit;

@interface GalleryViewController ()

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableDictionary *callbacks;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(120, 120);
    layout.minimumInteritemSpacing = 1;
    self.collectionView.collectionViewLayout = layout;
    
    [[ImgurApi sharedApi] fetchGalleryWithCompletion:^(NSArray *images) {
        self.images = images;
        [self.collectionView reloadData];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *imageUrl = self.images[indexPath.row];
    ImageCell *cell = (ImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell"
                                                                             forIndexPath:indexPath];
    NSLog(@"imageUrl: %@", imageUrl);
    [cell.imageView setImageWithURL:imageUrl];
    return cell;
}

@end
