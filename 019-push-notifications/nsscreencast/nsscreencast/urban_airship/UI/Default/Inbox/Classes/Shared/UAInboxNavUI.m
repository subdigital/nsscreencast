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

#import "UAInboxNavUI.h"
#import "UAInboxMessageListController.h"
#import "UAInboxMessageViewController.h"
#import "UAInboxOverlayController.h"

#import "UAInboxMessageList.h"
#import "UAInboxPushHandler.h"

@interface UAInboxNavUI ()

@property (nonatomic, retain) UIViewController *rootViewController;
@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, retain) UAInboxMessageViewController *messageViewController;
@property (nonatomic, retain) UAInboxMessageListController *messageListController;

- (void)quitInbox;

@end

@implementation UAInboxNavUI

@synthesize localizationBundle;
@synthesize rootViewController;
@synthesize inboxParentController;
@synthesize navigationController;
@synthesize messageListController;
@synthesize messageViewController;
@synthesize popoverController;
@synthesize popoverButton;
@synthesize useOverlay;
@synthesize isVisible;
@synthesize popoverSize;

SINGLETON_IMPLEMENTATION(UAInboxNavUI)

static BOOL runiPhoneTargetOniPad = NO;

+ (void)setRuniPhoneTargetOniPad:(BOOL)value {
    runiPhoneTargetOniPad = value;
}

- (void)dealloc {
    RELEASE_SAFELY(localizationBundle);
	RELEASE_SAFELY(alertHandler);
    RELEASE_SAFELY(rootViewController);
    RELEASE_SAFELY(inboxParentController);
    self.popoverController = nil;
    self.popoverButton = nil;
    self.navigationController = nil;
    self.messageListController = nil;
    self.messageViewController = nil;
    [super dealloc];
} 

- (id)init {
    if (self = [super init]) {
		
        NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UAInboxLocalization.bundle"];
        self.localizationBundle = [NSBundle bundleWithPath:path];
		
        self.useOverlay = NO;
        self.isVisible = NO;
        
        UAInboxMessageListController *mlc = [[[UAInboxMessageListController alloc] initWithNibName:@"UAInboxMessageListController" bundle:nil] autorelease];
        mlc.title = @"Inbox";
        mlc.navigationItem.leftBarButtonItem = 
            [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(inboxDone:)] autorelease];
        
        self.messageListController = mlc;
        
        alertHandler = [[UAInboxAlertHandler alloc] init];
        
        self.popoverSize = CGSizeMake(320, 1100);
    }
    
    return self;
}

- (void)inboxDone:(id)sender {
    [self quitInbox];
}

+ (void)displayInbox:(UIViewController *)viewController animated:(BOOL)animated {
    
    [[UAInbox shared].messageList addObserver:[UAInboxNavUI shared].messageListController];

    if ([UAInboxNavUI shared].isVisible) {
        //don't display twice
        return;
    }

    if ([viewController isKindOfClass:[UINavigationController class]]) {
        [UAInboxNavUI shared].isVisible = YES;
        if (viewController) {
            [UAInboxNavUI shared].inboxParentController = viewController;
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && !runiPhoneTargetOniPad) {
            [UAInboxNavUI shared].navigationController = [[[UINavigationController alloc] initWithRootViewController:[UAInboxNavUI shared].messageListController] autorelease];
            [UAInboxNavUI shared].popoverController = [[[UIPopoverController alloc] initWithContentViewController:[UAInboxNavUI shared].navigationController] autorelease];
            
            [UAInboxNavUI shared].popoverController.popoverContentSize = [UAInboxNavUI shared].popoverSize;
            [UAInboxNavUI shared].messageListController.contentSizeForViewInPopover = [UAInboxNavUI shared].popoverSize;
            
            [UAInboxNavUI shared].popoverController.delegate = [UAInboxNavUI shared];
            
            [[UAInboxNavUI shared].popoverController 
                presentPopoverFromBarButtonItem:[UAInboxNavUI shared].popoverButton
                       permittedArrowDirections:UIPopoverArrowDirectionAny
                                       animated:animated];
        } else {
            [UAInboxNavUI shared].navigationController = (UINavigationController *)viewController;
            [[UAInboxNavUI shared].navigationController pushViewController:[UAInboxNavUI shared].messageListController animated:animated];
        }
    } else {
        UALOG(@"Not a navigation controller");
    }

} 


+ (void)displayMessage:(UIViewController *)viewController message:(NSString *)messageID {

    if(![UAInboxNavUI shared].isVisible) {
        
        if ([UAInboxNavUI shared].useOverlay) {
            [UAInboxOverlayController showWindowInsideViewController:[UAInboxNavUI shared].inboxParentController withMessageID:messageID];
            return;
        }

        else {
            UALOG(@"UI needs to be brought up!");
            [UAInboxNavUI displayInbox:viewController?:[UAInboxNavUI shared].inboxParentController animated:NO];
        }
    }
	
    // If the message view is already open, just load the first message.
    if ([viewController isKindOfClass:[UINavigationController class]]) {
		
        // For iPhone
        UINavigationController *navController = (UINavigationController *)viewController;
        
		if ([navController.topViewController class] == [UAInboxMessageViewController class]) {
            [[UAInboxNavUI shared].messageViewController loadMessageForID:messageID];
        } else {
			
            [UAInboxNavUI shared].messageViewController = 
                [[[UAInboxMessageViewController alloc] initWithNibName:@"UAInboxMessageViewController" bundle:nil] autorelease];			
            [[UAInboxNavUI shared].messageViewController loadMessageForID:messageID];
            [navController pushViewController:[UAInboxNavUI shared].messageViewController animated:YES];
        }
    }
}

+ (void)quitInbox {
    [[UAInboxNavUI shared] quitInbox];
}

- (void)quitInbox {
    
    [[UAInbox shared].messageList removeObserver:[UAInboxNavUI shared].messageListController];
    
    self.isVisible = NO;
    [self.navigationController popToViewController:messageListController animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.popoverController) {
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }

    
}

+ (void)loadLaunchMessage {
	
	// if pushhandler has a messageID load it
    UAInboxPushHandler *pushHandler = [UAInbox shared].pushHandler;
	if (pushHandler.viewingMessageID && pushHandler.hasLaunchMessage) {

		UAInboxMessage *msg = [[UAInbox shared].messageList messageForID:pushHandler.viewingMessageID];
		if (!msg) {
			return;
		}
        
        UIViewController *rvc = [UAInboxNavUI shared].rootViewController;
		
		[UAInbox displayMessage:rvc message:pushHandler.viewingMessageID];
		
		pushHandler.viewingMessageID = nil;
		pushHandler.hasLaunchMessage = NO;
	}

}

+ (void)land {
    //do any necessary teardown here
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)dismissedPopoverController {
    if (self.popoverController == dismissedPopoverController) {
        [UAInbox quitInbox];
    }
}

- (void)newMessageArrived:(NSDictionary *)message {
    
    NSString* alertText = [[message objectForKey: @"aps"] objectForKey: @"alert"];
    [alertHandler showNewMessageAlert:alertText];
}


@end
