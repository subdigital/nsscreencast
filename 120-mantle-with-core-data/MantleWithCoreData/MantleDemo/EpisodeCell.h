//
//  EpisodeCell.h
//  MantleDemo
//
//  Created by ben on 5/10/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EpisodeCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

@end
