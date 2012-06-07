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

#import "UAInboxUI.h"
#import "UAInboxMessageListController.h"
#import "UAInboxMessageViewController.h"
#import "UAInboxOverlayController.h"

#import "UAInboxMessageList.h"
#import "UAInboxPushHandler.h"

@interface UAInboxUI ()

@property (nonatomic, retain) UIViewController *rootViewController;
@property (nonatomic, retain) UAInboxMessageListController *messageListController;
@property (nonatomic, retain) UAInboxAlertHandler *alertHandler;
@property (nonatomic, assign) BOOL isVisible;

- (void)quitInbox;

@end

@implementation UAInboxUI

@synthesize localizationBundle;
@synthesize rootViewController;
@synthesize messageListController;
@synthesize inboxParentController;
@synthesize alertHandler;
@synthesize useOverlay;
@synthesize isVisible;

SINGLETON_IMPLEMENTATION(UAInboxUI)

- (void)dealloc {
    RELEASE_SAFELY(localizationBundle);
	RELEASE_SAFELY(alertHandler);
    RELEASE_SAFELY(rootViewController);
    RELEASE_SAFELY(inboxParentController);
    [super dealloc];
} 

- (id)init {
    if (self = [super init]) {
		
        NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UAInboxLocalization.bundle"];
        self.localizationBundle = [NSBundle bundleWithPath:path];
		
        self.useOverlay = NO;
        self.isVisible = NO;
        
        self.messageListController = [[UAInboxMessageListController alloc] initWithNibName:@"UAInboxMessageListController" bundle:nil];
        messageListController.title = @"Inbox";
        messageListController.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(inboxDone:)] autorelease];
        
        self.rootViewController = [[[UINavigationController alloc] initWithRootViewController:messageListController] autorelease];
        
        alertHandler = [[UAInboxAlertHandler alloc] init];        		
    }
    
    return self;
}

- (void)inboxDone:(id)sender {
    [self quitInbox];
}

+ (void)displayInbox:(UIViewController *)viewController animated:(BOOL)animated {
    
    [[[UAInbox shared] messageList] addObserver:[UAInboxUI shared].messageListController];
	
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
    }

	[UAInboxUI shared].isVisible = YES;
    
    UALOG(@"present modal");
    [viewController presentModalViewController:[UAInboxUI shared].rootViewController animated:animated];
} 

+ (void)displayMessage:(UIViewController *)viewController message:(NSString *)messageID {

    if(![UAInboxUI shared].isVisible) {
        
        if ([UAInboxUI shared].useOverlay) {
            [UAInboxOverlayController showWindowInsideViewController:[UAInboxUI shared].inboxParentController withMessageID:messageID];
            return;
        }
        
        else {
            UALOG(@"UI needs to be brought up!");
            // We're not inside the modal/navigationcontroller setup so lets start with the parent
            [UAInboxUI displayInbox:[UAInboxUI shared].inboxParentController animated:NO]; // BUG?
        }
	}
		
    // For iPhone
    UINavigationController *navController = (UINavigationController *)[UAInboxUI shared].rootViewController;
    UAInboxMessageViewController *mvc;
    
    //if a message view is displaying, just load the new message
    if ([navController.topViewController class] == [UAInboxMessageViewController class]) {
        mvc = (UAInboxMessageViewController *) navController.topViewController;
        [mvc loadMessageForID:messageID];
    } 
    //otherwise, push over a new message view
    else {
        mvc = [[[UAInboxMessageViewController alloc] initWithNibName:@"UAInboxMessageViewController" bundle:nil] autorelease];			
        [mvc loadMessageForID:messageID];
        [navController pushViewController:mvc animated:YES];
    }
}

- (void)newMessageArrived:(NSDictionary *)message {
    
    NSString* alertText = [[message objectForKey: @"aps"] objectForKey: @"alert"];
    
    [alertHandler showNewMessageAlert:alertText];
}

- (void)quitInbox {
    
    [[[UAInbox shared] messageList] removeObserver:messageListController];

    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)rootViewController popToRootViewControllerAnimated:NO];
    }
	
    self.isVisible = NO;
    
    //added iOS 5 parent/presenting view getter
    UIViewController *con;
    if ([self.rootViewController respondsToSelector:@selector(presentingViewController)]) {
        con = [self.rootViewController presentingViewController];
    } else {
        con = self.rootViewController.parentViewController;
    }
    
    [con dismissModalViewControllerAnimated:YES];
    
    // BUG: Workaround. ModalViewController does not handle resizing correctly if
    // dismissed in landscape when status bar is visible
    if (![UIApplication sharedApplication].statusBarHidden) {
        con.view.frame = UAFrameForCurrentOrientation(con.view.frame);
    }
}

+ (void)quitInbox {
    [[UAInboxUI shared] quitInbox];
}

+ (void)loadLaunchMessage {
	
	// if pushhandler has a messageID load it
    UAInboxPushHandler *pushHandler = [UAInbox shared].pushHandler;

    UAInboxMessage *msg = [[UAInbox shared].messageList messageForID:pushHandler.viewingMessageID];
    
    if (!msg) {
        return;
    }
            
    [UAInboxUI displayMessage:nil message:pushHandler.viewingMessageID];
    
    pushHandler.viewingMessageID = nil;
    pushHandler.hasLaunchMessage = NO;
}

+ (void)land {
    //do any necessary teardown here
}

@end
