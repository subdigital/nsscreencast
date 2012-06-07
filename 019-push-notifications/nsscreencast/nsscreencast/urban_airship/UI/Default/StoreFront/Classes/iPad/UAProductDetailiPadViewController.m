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

#import "UAProductDetailiPadViewController.h"


@implementation UAProductDetailiPadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        webViewHeight = 0;
    }
    return self;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [detailTable reloadData];
}

#pragma mark -
#pragma mark TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)view cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (product.previewURL == nil) {
        return [super tableView:view cellForRowAtIndexPath:indexPath];
    }

    UIImage *bgImage = [UIImage imageNamed:@"middle-detail.png"];
    UIImage *stretchableBgImage = [bgImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    UIImageView *bgImageView = [[[UIImageView alloc] initWithImage:stretchableBgImage] autorelease];

    NSString* text = product.productDescription;
    UIFont *font = [UIFont systemFontOfSize: 16];
    UIWebView *webView = [[[UIWebView alloc] init] autorelease];
    NSString *htmlString = [self constructHtmlForWebViewWithDescription:text AndImageURL:product.previewURL];
    [webView loadHTMLString:htmlString baseURL:nil];
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:0];
    [webView setDelegate:self];

    CGFloat height = [text sizeWithFont: font
                      constrainedToSize: CGSizeMake(280.0, 800.0)
                          lineBreakMode: UILineBreakModeWordWrap].height;
    [webView setFrame:CGRectMake(0.0f, 10.0f, 320.0f, height)];
    [webView setBounds:CGRectMake(0.20f, 0.0f, 290.0f, height)];
    [webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier: @"description-cell"]
                             autorelease];
    [cell addSubview:webView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundView:bgImageView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)view heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (product.previewURL == nil || webViewHeight == 0) {
        return [super tableView:view heightForRowAtIndexPath:indexPath];
    } else {
        CGFloat height = webViewHeight;
        return height + kCellPaddingHeight;
    }
}

#pragma mark -
#pragma mark WebView

- (NSString *)constructHtmlForWebViewWithDescription:(NSString *)description AndImageURL:(NSURL *)imageURL {
    return [NSString stringWithFormat:@"<html> <body style=\"background-color: transparent; font-family: helvetica; font-size: 16px;\"> <img width=\"160\" src=\"%@\" align=\"right\" /> %@ </body> </html>",
            [imageURL description], description];
}

- (void)webViewDidFinishLoad:(UIWebView *)view {
    [view sizeToFit];
    NSString *output = [view stringByEvaluatingJavaScriptFromString:@"document.height;"];
    int currentHeight = [output intValue];
    if (currentHeight == webViewHeight) {
        return;
    }
    webViewHeight = currentHeight;
    [detailTable reloadData];
}

@end
