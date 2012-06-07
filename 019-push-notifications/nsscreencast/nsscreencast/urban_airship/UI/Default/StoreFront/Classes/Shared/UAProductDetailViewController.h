/*
Copyright 2009-2012 Urban Airship Inc. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2. Redistributions in binaryform must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided withthe distribution.

THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC ``AS IS'' AND ANY EXPRESS OR
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
#import "UAProduct.h"
#import "UAStoreFront.h"

#define kCellPaddingHeight 30

@interface UAProductDetailViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UAProductObserverProtocol> {
    IBOutlet UILabel* productTitle;
    IBOutlet UAAsyncImageView* iconContainer;
    IBOutlet UILabel* price;
    IBOutlet UILabel* revision;
    IBOutlet UILabel* fileSize;
    IBOutlet UITableView *detailTable;
    IBOutlet UITableViewCell *previewImageCell;
    IBOutlet UAAsyncImageView *previewImage;
    UIBarButtonItem *buyButton;
    BOOL wasBackgrounded;
    UAProduct* product;
}

@property (nonatomic, retain) UAProduct *product;
@property (nonatomic, retain) IBOutlet UILabel* productTitle;
@property (nonatomic, retain) IBOutlet UAAsyncImageView* iconContainer;
@property (nonatomic, retain) IBOutlet UILabel* price;
@property (nonatomic, retain) IBOutlet UILabel* revision;
@property (nonatomic, retain) IBOutlet UILabel* fileSize;
@property (nonatomic, retain) IBOutlet UITableView *detailTable;
@property (nonatomic, retain) IBOutlet UITableViewCell *previewImageCell;
@property (nonatomic, retain) IBOutlet UAAsyncImageView *previewImage;

- (void)purchase:(id)sender;
- (void)refreshUI;
- (void)refreshBuyButton;

@end
