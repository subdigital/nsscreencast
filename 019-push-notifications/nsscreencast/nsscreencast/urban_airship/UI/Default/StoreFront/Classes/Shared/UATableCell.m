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

#import "UATableCell.h"
#import "UAirship.h"

@implementation UATableCell

@synthesize isOdd;

-(void)dealloc {
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style  reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]) {
        self.isOdd = NO;
    }
    return self;
}

- (void)setIsOdd:(BOOL)odd {
    isOdd = odd;

    if (isOdd) {
        self.backgroundColor = RGBA(255, 255, 255, 1);
    } else {
        self.backgroundColor = RGBA(240, 242, 243, 1);
    }
}

/*
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();

    //Background
    CGRect drawRect = CGRectMake(rect.origin.x, rect.origin.y,
                                 rect.size.width, rect.size.height);

    if(self.isOdd) {
        BG_RGBA(255.0f, 255.0f, 255.0f, 1.0f);
    } else {
        BG_RGBA(240.0f, 242.0f, 243.0f, 1.0f);
    }
    CGContextFillRect(context, drawRect);

    //Highlight
    BG_RGBA(255.0f, 255.0f, 255.f, 1.0f);
    CGRect highlight = CGRectMake(rect.origin.x, rect.origin.y,
                                  rect.size.width , rect.origin.y+1);
    CGContextFillRect(context, highlight);

    //Lowlight
    BG_RGBA(230.0f, 230.0f, 230.0f, 1.0f);
    CGRect lowlight = CGRectMake(rect.origin.x, rect.size.height-1 ,
                                 rect.size.width , rect.size.height);
    CGContextFillRect(context, lowlight);
}*/

@end
