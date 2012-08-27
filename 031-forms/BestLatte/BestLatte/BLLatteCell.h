//
//  BLLatteCell.h
//  BestLatte
//
//  Created by Ben Scheirman on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KKGridViewCell.h"
#import "BLLatte.h"

@interface BLLatteCell : KKGridViewCell

@property (nonatomic, strong) UIImageView *imageView;

- (void)setLatte:(BLLatte *)latte;

@end
