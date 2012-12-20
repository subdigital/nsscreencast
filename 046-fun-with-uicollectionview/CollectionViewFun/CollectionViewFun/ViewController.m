//
//  ViewController.m
//  CollectionViewFun
//
//  Created by ben on 12/17/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import "ViewController.h"
#import "NumberCell.h"
#import "WaveLayout.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView registerClass:[NumberCell class]
            forCellWithReuseIdentifier:@"cell"];

    WaveLayout *waveLayout = [[WaveLayout alloc] init];
    self.collectionView.collectionViewLayout = waveLayout;
}

#pragma mark - 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NumberCell *cell = (NumberCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                               forIndexPath:indexPath];
    [cell setNumber:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected item %d", indexPath.row);
}


@end
