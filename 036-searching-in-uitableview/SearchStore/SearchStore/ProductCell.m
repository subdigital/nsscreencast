//
//  ProductCell.m
//  SearchStore
//
//  Created by Ben Scheirman on 9/30/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.000];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView.backgroundColor = self.backgroundColor;
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.priceLabel];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.backgroundColor = [UIColor clearColor];
    } else {
        self.textLabel.backgroundColor = self.backgroundView.backgroundColor;
        self.detailTextLabel.backgroundColor = self.backgroundView.backgroundColor;
        self.priceLabel.backgroundColor = self.backgroundView.backgroundColor;
    }
    
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.backgroundColor = [UIColor clearColor];
    } else {
        self.textLabel.backgroundColor = self.backgroundView.backgroundColor;
        self.detailTextLabel.backgroundColor = self.backgroundView.backgroundColor;
        self.priceLabel.backgroundColor = self.backgroundView.backgroundColor;
    }
    
    [self setNeedsDisplay];
}

- (void)setProduct:(Product *)product {
    _product = product;
    self.textLabel.text = product.name;
    self.detailTextLabel.text = product.category.name;
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", product.price];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    const CGFloat PriceLabelWidth = 40;
    const CGFloat Margin = 10;
    
    self.textLabel.textColor = [UIColor darkGrayColor];
    CGRect textFrame = self.textLabel.frame;
    textFrame.size.width = self.frame.size.width - PriceLabelWidth - (2 * Margin);
    self.textLabel.frame = textFrame;
    
    self.detailTextLabel.textColor = [UIColor colorWithRed:0.475 green:0.620 blue:0.351 alpha:1.000];
    
    self.priceLabel.font = [UIFont boldSystemFontOfSize:11];
    self.priceLabel.textColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.541 alpha:0.650];
 
    self.backgroundView.frame = self.bounds;
    
    self.priceLabel.frame = CGRectMake(self.bounds.size.width - PriceLabelWidth - Margin, 0, PriceLabelWidth, self.bounds.size.height);
}

@end
