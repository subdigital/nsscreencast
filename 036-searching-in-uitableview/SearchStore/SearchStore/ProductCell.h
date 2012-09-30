//
//  ProductCell.h
//  SearchStore
//
//  Created by Ben Scheirman on 9/30/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "Category.h"

@interface ProductCell : UITableViewCell

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) Product *product;


@end
