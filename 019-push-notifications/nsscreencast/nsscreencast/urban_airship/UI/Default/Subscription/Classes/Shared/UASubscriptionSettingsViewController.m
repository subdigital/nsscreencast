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


#import "UASubscriptionSettingsViewController.h"
#import "UAGlobal.h"
#import "UASubscriptionUI.h"


@implementation UASubscriptionSettingsViewController
@synthesize emailHints, emailInput, emailButton, resendEmailButton, recoveryHints;
@synthesize cancelEmailButton;
@synthesize recoveryAlert;


- (void)dealloc {
    RELEASE_SAFELY(emailHints);
    RELEASE_SAFELY(emailInput);
    RELEASE_SAFELY(emailButton);
    RELEASE_SAFELY(resendEmailButton);
    RELEASE_SAFELY(recoveryHints);
    RELEASE_SAFELY(cancelEmailButton);
    RELEASE_SAFELY(recoveryAlert);

    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[UAUser defaultUser] addObserver:self];
    }
    return self;
}

- (void)viewDidLoad {
    [self updateUI];
    [emailButton setTitle:UA_SS_TR(@"UA_Submit") forState:UIControlStateNormal];
    [resendEmailButton setTitle:UA_SS_TR(@"UA_Resend") forState:UIControlStateNormal];
    [cancelEmailButton setTitle:UA_SS_TR(@"UA_Cancel") forState:UIControlStateNormal];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {    // Called when the view is about to made visible. Default does nothing
    [self updateUI];
}

- (void)updateUI {
    UAUserState userState = [UAUser defaultUser].userState;
    UALOG(@"User state: %d", userState);
    if (userState == UAUserStateEmpty  || userState == UAUserStateCreating) {
        emailHints.text = UA_SS_TR(@"UA_Email_Hints_Empty");
        emailInput.hidden = NO;
        emailInput.enabled = YES;
        emailInput.text = @"";
        emailButton.hidden = NO;
        emailButton.enabled = YES;
        resendEmailButton.hidden = YES;
        cancelEmailButton.hidden = YES;
        recoveryHints.text = @"";
    } else if (userState == UAUserStateNoEmail) {
        emailHints.text = UA_SS_TR(@"UA_Email_Hints_NoEmail");
        emailInput.hidden = NO;
        emailInput.text = @"";
        emailInput.enabled = YES;
        emailButton.hidden = NO;
        emailButton.enabled = YES;
        resendEmailButton.hidden = YES;
        cancelEmailButton.hidden = YES;
        recoveryHints.text = @"";
    } else if (userState == UAUserStateWithEmail) {
        emailHints.text = UA_SS_TR(@"UA_Email_Hints_WithEmail");
        emailInput.text = [UAUser defaultUser].email;
        emailInput.hidden = NO;
        emailInput.enabled = YES;
        emailButton.hidden = NO;
        emailButton.enabled = YES;
        resendEmailButton.hidden = YES;
        cancelEmailButton.hidden = YES;
        recoveryHints.text = @"";
    } else if (userState == UAUserStateInRecovery) {
        recoveryHints.text = UA_SS_TR(@"UA_In_Recovery");
        emailInput.text = [UAUser defaultUser].recoveryEmail;
        emailInput.hidden = NO;
        emailButton.hidden = NO;
        emailButton.enabled = YES;
        resendEmailButton.hidden = YES;
        cancelEmailButton.hidden = YES;
        if ([UAUser defaultUser].sentRecoveryEmail) {
            emailHints.text = UA_SS_TR(@"UA_Email_Hints_InRecovery");
            emailInput.enabled = NO;
            emailButton.hidden = YES;
            cancelEmailButton.hidden = NO;
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (IBAction)resendEmail:(id)sender {
    /*
    [[UAUser defaultUser] startRecovery];
    UIAlertView *recoveryAlert = [[[UIAlertView alloc] initWithTitle: @"Recovering Account"
                                               message:@"We re-sent you an email with a link and instructions to recover it."
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"Ok",
                                   nil] autorelease];
    [recoveryAlert show];
     */
}

- (IBAction)cancelEmail:(id)sender {
    [[UAUser defaultUser] cancelRecovery];
    [self updateUI];
}

- (IBAction)submitEmail:(id)sender {
    // validate email address in client side
	if ([self validateEmail:emailInput.text]) {
		emailButton.enabled = ![[UAUser defaultUser] setUserEmail:emailInput.text];
		[emailInput resignFirstResponder];
	}
}

- (BOOL)validateEmail:(NSString *) candidate {
	
	// Complete RFC 2822 regex
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx]; 
	
    return [emailTest evaluateWithObject:candidate];
}

#pragma mark UAUserObserver

- (void)userUpdated {
    UALOG(@"Observer notified: userUpdated");
    [self updateUI];
}

- (void)userUpdateFailed {
    UALOG(@"Observer notified: userUpdateFailed");
    emailButton.enabled = YES;
}

- (void)userRecoveryStarted {
    UALOG(@"Observer notified: userRecoveryStarted");
    recoveryHints.text = UA_SS_TR(@"UA_In_Recovery");
    
    [self hideRecoveryAlert];
    [self showRecoveryAlert];
}

- (void)userRecoveryFinished {
    UALOG(@"Observer notified: userRecoveryFinished");
    recoveryHints.text = UA_SS_TR(@"UA_Recovery_OK");
    
    // The recoveryAlert might still be up here - dismiss it
    [self hideRecoveryAlert];
}

- (void)userRecoveryFailed {
    UALOG(@"Observer notified: userRecoveryFailed");
    recoveryHints.text = UA_SS_TR(@"UA_Recovery_Failed");
    
    // The recoveryAlert might still be up here - dismiss it
    [self hideRecoveryAlert];
    [self showRecoveryFailAlert];
}

#pragma mark Alert View

- (void)showRecoveryAlert {
    self.recoveryAlert = [[[UIAlertView alloc] initWithTitle: UA_SS_TR(@"UA_Recovering_Account")
                                               message: UA_SS_TR(@"UA_Recovery_Alert")
                                              delegate: nil
                                     cancelButtonTitle: nil
                                     otherButtonTitles: UA_SS_TR(@"UA_OK"),
                          nil] autorelease];
    [recoveryAlert show];
}

- (void)hideRecoveryAlert {
    if(recoveryAlert.visible) {
        // If for some reason the recovery pop-up is still up (launched in an async response to "userUpdatedEmail"), dismiss it
        [recoveryAlert dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)showRecoveryFailAlert {
    UIAlertView* failAlert = [[UIAlertView alloc] initWithTitle: UA_SS_TR(@"UA_Recovery_Failed")
                                                        message: UA_SS_TR(@"UA_Recovery_Fail_Alert")
                                                       delegate: nil
                                              cancelButtonTitle: nil
                                              otherButtonTitles: UA_SS_TR(@"UA_OK"), nil];
    [failAlert show];
    [failAlert release];
}

@end
