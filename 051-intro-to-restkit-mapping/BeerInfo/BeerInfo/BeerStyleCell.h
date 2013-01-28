//
//  BeerStyleCell.h
//  BeerInfo
//
//  Created by ben on 1/26/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeerStyleCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *styleNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *styleDescriptionLabel;
@property (nonatomic, strong) IBOutlet UILabel *styleCategoryLabel;

@end
