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


#import <UIKit/UIKit.h>
#import "UAUser.h"
#define kCellPaddingHeight 30

@class UAAsyncImageView;
@class UASubscriptionProduct;
@protocol UASubscriptionAlertProtocol;

@interface UASubscriptionProductDetailViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource> {
    
    UILabel *productTitle;
    UAAsyncImageView *iconContainer;
    UILabel *price;
    UITableView *detailTable;
    UITableViewCell *previewImageCell;
    UAAsyncImageView *previewImage;
    UIBarButtonItem *buyButton;
    NSString *productId;
    
    id<UASubscriptionAlertProtocol> alertDelegate;
}

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, retain) IBOutlet UILabel *productTitle;
@property (nonatomic, retain) IBOutlet UAAsyncImageView *iconContainer;
@property (nonatomic, retain) IBOutlet UILabel *price;
@property (nonatomic, retain) IBOutlet UITableView *detailTable;
@property (nonatomic, retain) IBOutlet UITableViewCell *previewImageCell;
@property (nonatomic, retain) IBOutlet UAAsyncImageView *previewImage;
@property (nonatomic, assign) id<UASubscriptionAlertProtocol> alertDelegate;

- (void)setProduct:(UASubscriptionProduct *)product;
- (void)purchase:(id)sender;
- (void)refreshUI;
- (BOOL)showUserEmailAlertOnce;

@end
