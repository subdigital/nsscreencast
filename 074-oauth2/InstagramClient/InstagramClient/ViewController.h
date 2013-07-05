//
//  ViewController.h
//  InstagramClient
//
//  Created by ben on 6/30/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
- (IBAction)fetchTimeline:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
