//
//  OILEntryCell.h
//  OilChangeApp
//
//  Created by ben on 5/26/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OILEntryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *milesLabel;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageConstraint;

@end
