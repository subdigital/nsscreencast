/*
 Copyright 2009-2012 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UASubscriptionProductCell.h"
#import "UAGlobal.h"


@implementation UASubscriptionProductCell

@synthesize iconContainer;
@synthesize product;
@synthesize cellView;

- (void)dealloc {
    product = nil;
    RELEASE_SAFELY(iconContainer);
    RELEASE_SAFELY(cellView);

    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]))
        return nil;

    iconContainer = [[UAAsyncImageView alloc] initWithFrame:CGRectMake(11, 11, 57, 57)];

    cellView = [[UASubscriptionProductCellView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    cellView.product = self.product;
    cellView.contentMode = UIViewContentModeRedraw;
    self.contentMode = UIViewContentModeScaleToFill;

    [self.contentView addSubview:cellView];
    [self.contentView addSubview:iconContainer];

    return self;
}

- (void)setFrame:(CGRect)frame {
    if (self.frame.size.width != frame.size.width) {
        cellView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    [super setFrame:frame];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [cellView setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [cellView setSelected:selected];
}

- (void)setProduct:(UASubscriptionProduct*)newProduct {
    if (product == newProduct)
        return;

    product = newProduct;
    cellView.product = product;
    [iconContainer loadImageFromURL:product.iconURL];
    [cellView refreshCellView];
}

@end
