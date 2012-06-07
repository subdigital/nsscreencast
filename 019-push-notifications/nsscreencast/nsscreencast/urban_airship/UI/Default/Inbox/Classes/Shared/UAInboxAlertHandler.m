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

#import "UAInboxAlertHandler.h"
#import "UAInboxUI.h"

#import "UAInboxPushHandler.h"
#import "UAInboxMessageList.h"

// Weak link to this notification since it doesn't exist in iOS 3.x
UIKIT_EXTERN NSString* const UIApplicationDidEnterBackgroundNotification __attribute__((weak_import));

@implementation UAInboxAlertHandler

- (id)init {
    if (self = [super init]) {
        IF_IOS4_OR_GREATER(
                           
           if (&UIApplicationDidEnterBackgroundNotification != NULL) {
               
               [[NSNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(enterBackground)
                                                            name:UIApplicationDidEnterBackgroundNotification
                                                          object:nil];
           }
        );
    }
    
    return self;
}

- (void)dealloc {
    RELEASE_SAFELY(notificationAlert);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)enterBackground {
    [notificationAlert dismissWithClickedButtonIndex:0 animated:NO];
    [[UAInbox shared].pushHandler setViewingMessageID:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == alertView.cancelButtonIndex) {
		// If we cancel, clear the pushHandler viewmessageID
		[[UAInbox shared].pushHandler setViewingMessageID:nil];
    }
    
    //retrieve the message list -- if viewmessageID is non-nil,
    //the corresponding message will be displayed.
    [[UAInbox shared].messageList retrieveMessageList];

    RELEASE_SAFELY(notificationAlert);
}

- (void)showNewMessageAlert:(NSString *)message {
    /* In the event that one happens to be showing. (These are no-ops if notificationAlert is nil.) */
    [notificationAlert dismissWithClickedButtonIndex:0 animated:NO];
    RELEASE_SAFELY(notificationAlert);
	
    /* display a new alert */
	notificationAlert = [[UIAlertView alloc] initWithTitle:UA_INBOX_TR(@"UA_Remote_Notification_Title")
                                                                 message:message
                                                                delegate:self
                                                       cancelButtonTitle:UA_INBOX_TR(@"UA_OK")
                                                       otherButtonTitles:UA_INBOX_TR(@"UA_View"),
                                       nil];
    [notificationAlert show];
	
}

@end
