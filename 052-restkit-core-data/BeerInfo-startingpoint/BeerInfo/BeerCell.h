//
//  BeerCell.h
//  BeerInfo
//
//  Created by ben on 1/26/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeerCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *labelImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *abvLabel;
@property (nonatomic, strong) IBOutlet UILabel *ibuLabel;
@property (nonatomic, strong) IBOutlet UILabel *breweryLabel;

@end
