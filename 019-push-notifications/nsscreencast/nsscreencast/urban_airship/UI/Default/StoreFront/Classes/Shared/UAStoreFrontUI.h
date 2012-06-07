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

#import <Foundation/Foundation.h>

#import "UAirship.h"
#import "UAStoreFront.h"
#import "UAStoreFrontAlertHandler.h"

#define UA_SF_TR(key) [[UAStoreFrontUI shared].localizationBundle localizedStringForKey:key value:@"" table:nil]

@class UAStoreFrontViewController;
@class UAStoreFrontAlertProtocol;

/**
 * This class is the reference implementation of the UAStoreFrontUIProtocol.
 */

@interface UAStoreFrontUI : NSObject <UAStoreFrontUIProtocol> {

    UIWindow *uaWindow;

    UIViewController *rootViewController;
    UAStoreFrontViewController *productListViewController;
    
    BOOL isVisible;
    BOOL isiPad;
    BOOL animated;

    UAStoreFrontAlertHandler *alertHandler;

    NSBundle *localizationBundle;

@private
    UIWindow *originalWindow;

}

@property (nonatomic, retain) UIWindow *uaWindow;
@property (nonatomic, retain) UIWindow *originalWindow;
@property (nonatomic, retain, readonly) UIViewController *rootViewController;
@property (nonatomic, retain, readonly) UAStoreFrontViewController *productListViewController;
@property (nonatomic, assign, readonly) BOOL isVisible;
@property (nonatomic, assign, readonly) BOOL isiPad;
@property (nonatomic, retain) NSBundle *localizationBundle;

SINGLETON_INTERFACE(UAStoreFrontUI)

+ (void)setRuniPhoneTargetOniPad:(BOOL)value;
+ (void)displayStoreFront:(UIViewController *)viewController animated:(BOOL)animated;
+ (void)displayStoreFront:(UIViewController *)viewController withProductID:(NSString *)productID animated:(BOOL)animated;

@end
