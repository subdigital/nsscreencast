//
//  PlaylistItemCollectionViewCell.h
//  RoadTripDJ
//
//  Created by Ben Scheirman on 3/11/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistItemCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView* imageView;
@property (nonatomic, weak) IBOutlet UILabel* artistLabel;
@property (nonatomic, weak) IBOutlet UILabel* songLabel;

@end
