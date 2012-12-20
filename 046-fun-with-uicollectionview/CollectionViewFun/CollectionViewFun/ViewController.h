//
//  ViewController.h
//  CollectionViewFun
//
//  Created by ben on 12/17/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
