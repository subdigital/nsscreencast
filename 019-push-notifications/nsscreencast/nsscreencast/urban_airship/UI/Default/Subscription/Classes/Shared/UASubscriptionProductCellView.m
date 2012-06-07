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

#import <QuartzCore/QuartzCore.h>
#import "UASubscriptionProductCellView.h"
#import "UAGlobal.h"
#import "UAUtils.h"
#import "UASubscriptionUI.h"
#import "UASubscriptionUIUtil.h"

// Private methods
@interface UASubscriptionProductCellView()
- (void)updateTitle;
@end

@implementation UASubscriptionProductCellView

@synthesize title, description, price, product, priceColor, priceBgColor, priceBorderColor;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        product = nil;
        title = nil;
        description = nil;
        price = nil;
        priceColor = nil;
        priceBgColor = nil;
        priceBorderColor = nil;
        selected = FALSE;
        highlighted = FALSE;
    }

    return self;
}


- (void)dealloc {
    product = nil;
    RELEASE_SAFELY(title);
    RELEASE_SAFELY(description);
    RELEASE_SAFELY(price);
    RELEASE_SAFELY(priceColor);
    RELEASE_SAFELY(priceBgColor);
    RELEASE_SAFELY(priceBorderColor);

    [super dealloc];
}

- (void)setHighlighted:(BOOL)h {
    if (highlighted != h) {
        highlighted = h;
        [self setNeedsDisplay];
    }
}

- (void)setSelected:(BOOL)s {
    if (selected != s) {
        selected = s;
        [self setNeedsDisplay];
    }
}

#pragma mark -
#pragma mark Refresh UI



- (void)refreshPriceLabelView {
    //update color
    NSString *text;
    UIColor *textColor, *bgColor, *borderColor;

    NSDate *now = [NSDate date];
    
    if (product.purchased && [UASubscriptionUIUtil date:now isBetweenDate:product.startDate andDate:product.endDate]) {
        text = UA_SS_TR(@"UA_Subscribed");
        borderColor = textColor = kInstalledFGColor;
        bgColor = kInstalledBGColor;
    } else if (product.purchased) {
        text = UA_SS_TR(@"UA_Expired");
        borderColor = textColor = kUpdateFGColor;
        bgColor = kUpdateBGColor;
    } else {
        text = product.price;
        textColor = kPriceFGColor;
        borderColor = kPriceBorderColor;
        bgColor = kPriceBGColor;
    }

    self.price = text;
    self.priceColor = textColor;
    self.priceBgColor = bgColor;
    self.priceBorderColor = borderColor;
}

- (void)refreshDescriptionLabelView {
    if (product.purchased) {
        NSDateFormatter *generateStringformatter = [[[NSDateFormatter alloc] init] autorelease];
        [generateStringformatter setDateStyle:NSDateFormatterMediumStyle]; // Will produce localized date
        [generateStringformatter setTimeStyle:NSDateFormatterMediumStyle];
        //[generateStringformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSString *start = [generateStringformatter stringFromDate:product.startDate];
        NSString *end = [generateStringformatter stringFromDate:product.endDate];
        self.description = [NSString stringWithFormat:@"%@ - %@", start, end];
    } else {
        self.description = product.productDescription;
    }
}

- (void)updateTitle {
    NSString* arDurationString;
    switch (product.productType) {
        case UASubscriptionProductTypeAutorenewable:
            arDurationString = [UASubscriptionUIUtil localizedAutorenewableDuration:product.autorenewableDuration];
            self.title = [product.title stringByAppendingFormat:@" (%@)", arDurationString];
            break;
        case UASubscriptionProductTypeFree:
            arDurationString = UA_SS_TR(@"UA_Free_Subscription");
            self.title = [product.title stringByAppendingFormat:@" (%@)", arDurationString];
            break;
        default:
            self.title = product.title;
            break;
    }
}

- (void)refreshCellView {
    [self updateTitle];
    [self refreshDescriptionLabelView];
    [self refreshPriceLabelView];
    [self setNeedsDisplay];
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect,
                                 float ovalWidth,float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) { // 1
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context); // 2
    CGContextTranslateCTM (context, CGRectGetMinX(rect), // 3
                           CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight); // 4
    fw = CGRectGetWidth (rect) / ovalWidth; // 5
    fh = CGRectGetHeight (rect) / ovalHeight; // 6
    CGContextMoveToPoint(context, fw, fh/2); // 7
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1); // 8
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // 9
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // 10
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
    CGContextClosePath(context); // 12
    CGContextRestoreGState(context); // 13
}

- (float)getWidth:(NSString *)string {
    CGSize size;
    size = [string sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]];
    return size.width;
}

#define RIGHT_BOUNDARY  18.0
- (void)drawRect:(CGRect)r {
    CGRect rect;
    UIColor *fontColor;
    float width = self.frame.size.width;

    if (highlighted || selected) {
        fontColor = [UIColor whiteColor];
    } else {
        fontColor = [UIColor blackColor];
    }

    float w = [self getWidth:price];

    [fontColor set];
    rect = CGRectMake(76, 11, width-RIGHT_BOUNDARY-w-76, 20);
    [title drawInRect:rect
             withFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]
        lineBreakMode:UILineBreakModeTailTruncation
            alignment:UITextAlignmentLeft];


    CGContextRef context = UIGraphicsGetCurrentContext();
    addRoundedRectToPath(context, CGRectMake(width-RIGHT_BOUNDARY-w-3, 4, w+6, 24), 5.0f, 5.0f);
    CGContextSetFillColorWithColor(context, [priceBorderColor CGColor]);
    CGContextFillPath(context);

    context = UIGraphicsGetCurrentContext();
    addRoundedRectToPath(context, CGRectMake(width-RIGHT_BOUNDARY-w-2, 5, w+4, 22), 5.0f, 5.0f);
    CGContextSetFillColorWithColor(context, [priceBgColor CGColor]);
    CGContextFillPath(context);

    [priceColor set];
    rect = CGRectMake(width-RIGHT_BOUNDARY-w, 8, w, 20);
    [price drawInRect:rect
             withFont:[UIFont fontWithName:@"Helvetica" size:14]
        lineBreakMode:UILineBreakModeTailTruncation
            alignment:UITextAlignmentCenter];

    if (descriptionHidden == NO) {
        [fontColor set];
        rect = CGRectMake(77, 31, width-RIGHT_BOUNDARY-77, 33);
        [description drawInRect:rect
                       withFont:[UIFont fontWithName:@"Helvetica" size:13]
                  lineBreakMode:UILineBreakModeTailTruncation
                      alignment:UITextAlignmentLeft];
    }
}

@end
