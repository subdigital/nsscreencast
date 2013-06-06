//
//  OILEntryCell.m
//  OilChangeApp
//
//  Created by ben on 5/26/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import "OILEntryCell.h"

@implementation OILEntryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (NSLayoutConstraint *constraint in self.constraints) {
        [self removeConstraint:constraint];
        id firstItem = constraint.firstItem == self ? self.contentView : constraint.firstItem;
        id secondItem = constraint.secondItem == self ? self.contentView : constraint.secondItem;
        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                         attribute:constraint.firstAttribute
                                                                         relatedBy:constraint.relation
                                                                            toItem:secondItem
                                                                         attribute:constraint.secondAttribute
                                                                        multiplier:constraint.multiplier
                                                                          constant:constraint.constant];
        [self.contentView addConstraint:newConstraint];
    }
}

@end
