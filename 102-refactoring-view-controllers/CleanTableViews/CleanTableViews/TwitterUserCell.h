//
//  TwitterUserCell.h
//  CleanTableViews
//
//  Created by ben on 1/5/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterUserCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *screenNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;

@end
