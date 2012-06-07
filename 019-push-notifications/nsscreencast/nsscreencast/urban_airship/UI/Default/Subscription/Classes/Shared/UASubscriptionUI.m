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

#import "UASubscriptionUI.h"
#import "UASubscriptionRootViewController.h"
#import "UASubscriptionObserver.h"

@implementation UASubscriptionUI

@synthesize rootViewController;
@synthesize invokingViewController;
@synthesize subscriptionAlert;
@synthesize localizationBundle;
@synthesize displayAnimated;


SINGLETON_IMPLEMENTATION(UASubscriptionUI)


+ (void)displaySubscription:(UIViewController *) viewController
                   animated:(BOOL) animated {
	
    UASubscriptionUI *ui = [UASubscriptionUI shared];
    
	ui.displayAnimated = animated;
    ui.invokingViewController = viewController;
	
    [viewController presentModalViewController:ui.rootViewController animated:animated];
}


+ (void)hideSubscription {
	
    UASubscriptionUI *ui = [UASubscriptionUI shared];
	
    [ui.rootViewController dismissModalViewControllerAnimated:ui.displayAnimated];
}


- (id)init {
	
    if (!(self = [super init]))
        return nil;
	
    NSString *path = [[[NSBundle mainBundle] resourcePath]
                      stringByAppendingPathComponent:@"UASubscriptionLocalization.bundle"];
	
    self.localizationBundle = [NSBundle bundleWithPath:path];
    
	UIViewController *controller = [[[UASubscriptionRootViewController alloc]
                                     initWithNibName:@"UASubscriptionRootViewController"
                                     bundle:nil] autorelease];
    
	UASubscriptionAlertHandler *alertHandler = [[UASubscriptionAlertHandler alloc] init];
    self.subscriptionAlert = alertHandler;
	[alertHandler release];
    
    [UASubscriptionManager shared].transactionObserver.alertDelegate = subscriptionAlert;
    
	rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    
	return self;
}


- (void)dealloc {
	
	RELEASE_SAFELY(rootViewController);
    RELEASE_SAFELY(invokingViewController);
    RELEASE_SAFELY(subscriptionAlert);
    RELEASE_SAFELY(localizationBundle);

    [super dealloc];
}

@end
