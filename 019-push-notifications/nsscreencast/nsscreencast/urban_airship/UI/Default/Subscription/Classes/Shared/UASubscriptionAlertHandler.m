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

#import "UASubscriptionAlertHandler.h"
#import "UASubscriptionAlertProtocol.h"
#import "UASubscriptionUI.h"

@implementation UASubscriptionAlertHandler

- (id)init {
	
    if(!(self = [super init]))
        return nil;
	
    emailAlertReference = nil;
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUpdateOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    return self;
}


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


- (void) updateUserEmailAlert: (NSTimer *)timer{
    if (!emailAlertReference) {
        return;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL  isLandscape = UIInterfaceOrientationIsLandscape(orientation);
    
    float frameOriginY = emailAlertReference.frame.origin.y;
    [UIView beginAnimations:@"updateEmailAlert" context:NULL];
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType hasPrefix:@"iPad"]) {
        if (isLandscape) {
            frameOriginY -= 109;
            IF_IOS4_OR_GREATER(frameOriginY += 109;)
        }
    } else {
        frameOriginY -= 109;
        IF_IOS4_OR_GREATER(frameOriginY += 109;)
    }
    CGRect newFrame = CGRectMake(emailAlertReference.frame.origin.x, frameOriginY,
                                  emailAlertReference.frame.size.width, emailAlertReference.frame.size.height);
    emailAlertReference.frame = newFrame;
    
    IF_IOS4_OR_GREATER(
        CGRect emailFieldFrame = isLandscape ?
                       CGRectMake(10.0, 73.0, 284-20, 26.0) :
                       CGRectMake(10.0, 89.0, 284-20, 26.0);
        UITextField *field = (UITextField *)[emailAlertReference viewWithTag:180];
        field.frame = emailFieldFrame;
    )
    [UIView commitAnimations];
}


- (void)showUserEmailAlert:(id)sender {
    UIAlertView *emailInputView = [[[UIAlertView alloc] initWithTitle:UA_SS_TR(@"UA_Enter_Email_Title")
                                                              message:UA_SS_TR(@"UA_Enter_Email")
                                                             delegate:self
                                                    cancelButtonTitle:UA_SS_TR(@"UA_Cancel")
                                                    otherButtonTitles:UA_SS_TR(@"UA_OK"), nil]
                                   autorelease];
    CGRect emailFieldFrame = CGRectMake(10.0, 89.0, 284-20, 26.0);
    UITextField *field = [[[UITextField alloc] initWithFrame:emailFieldFrame] autorelease];
    field.tag = 180;

    field.borderStyle = UITextBorderStyleRoundedRect;
    field.backgroundColor = [UIColor clearColor];
    field.placeholder = @"bob@example.com";
    field.returnKeyType = UIReturnKeyDone;
    field.keyboardType = UIKeyboardTypeEmailAddress;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.autocorrectionType = UITextAutocorrectionTypeNo;

    [field addTarget:self
              action:@selector(emailFieldDone:)
    forControlEvents:UIControlEventEditingDidEndOnExit];

    [emailInputView addSubview:field];
    [emailInputView show];
}


- (void)didPresentAlertView:(UIAlertView *)alertView {
    [(UITextField *)[alertView viewWithTag:180] becomeFirstResponder];
    emailAlertReference = alertView;
    [self updateUserEmailAlert:nil];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [(UITextField *)[alertView viewWithTag:180] resignFirstResponder];
    emailAlertReference = nil;
    if (buttonIndex == 1) {
        [[UAUser defaultUser] modifyUserWithEmail:[(UITextField *)[alertView viewWithTag:180] text]];
    }
}


- (void)failedTransactionAlert:(id)sender {
    UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle:UA_SS_TR(@"UA_Purchase_Error_Title")
                                                           message:UA_SS_TR(@"UA_Purchase_Error")
                                                          delegate:nil
                                                 cancelButtonTitle:UA_SS_TR(@"UA_OK")
                                                 otherButtonTitles:nil];
    [failureAlert show];
    [failureAlert release];
}

- (void)failedRestoreAlert:(id)sender {
    UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle:UA_SS_TR(@"UA_Autorenewable_Restore_Error_Title")
                                                           message:UA_SS_TR(@"UA_Autorenewable_Restore_Error")
                                                          delegate:nil
                                                 cancelButtonTitle:UA_SS_TR(@"UA_OK")
                                                 otherButtonTitles:nil];
    [failureAlert show];
    [failureAlert release];
}


- (void)emailFieldDone:(id)sender {
    [sender resignFirstResponder];
}


- (void)onUpdateOrientation: (NSNotification *)notification {
    if (emailAlertReference) {
        //For the iPad 3.2 to work (need to adjust frame position, need to use
        //a timer here, for iOS4, no need to change frame position, thus no need
        //to have a timer.
        [NSTimer scheduledTimerWithTimeInterval:0.25f
                                         target:self
                                       selector:@selector(updateUserEmailAlert:)
                                       userInfo:nil
                                        repeats:NO];
    }
}


#pragma mark -
#pragma mark UASubscriptionAlertProtocol

- (void)showAlert:(UASubscriptionAlertType)type for:(id)sender {
    switch (type) {
        case UASubscriptionAlertShowUserEmail:
            [self showUserEmailAlert:sender];
            break;
        case UASubscriptionAlertFailedTransaction:
            [self failedTransactionAlert:sender];
            break;
        case UASubscriptionAlertFailedRestore:
            [self failedRestoreAlert:sender];
            break;
        default:
            break;
    }
}

@end

