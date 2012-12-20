//
//  NumberCell.h
//  CollectionViewFun
//
//  Created by ben on 12/17/12.
//  Copyright (c) 2012 nsscreencast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;

- (void)setNumber:(NSInteger)number;

@end
