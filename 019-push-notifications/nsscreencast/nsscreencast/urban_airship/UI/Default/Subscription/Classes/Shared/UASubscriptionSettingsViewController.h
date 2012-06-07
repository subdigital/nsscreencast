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

#import <UIKit/UIKit.h>
#import "UAUser.h"

@interface UASubscriptionSettingsViewController : UIViewController
<UAUserObserver, UIAlertViewDelegate> {
    UILabel *emailHints;
    UITextField *emailInput;
    UIButton *emailButton;
    UIButton *resendEmailButton;
    UIButton *cancelEmailButton;
    UILabel *recoveryHints;
    UIAlertView* recoveryAlert;
}

@property (retain) IBOutlet UILabel *emailHints;
@property (retain) IBOutlet UITextField *emailInput;
@property (retain) IBOutlet UIButton *emailButton;
@property (retain) IBOutlet UIButton *resendEmailButton;
@property (retain) IBOutlet UIButton *cancelEmailButton;
@property (retain) IBOutlet UILabel *recoveryHints;
@property (retain, nonatomic) UIAlertView *recoveryAlert;

- (IBAction)submitEmail:(id)sender;
- (IBAction)resendEmail:(id)sender;
- (IBAction)cancelEmail:(id)sender;
- (void)updateUI;

- (void)showRecoveryAlert;
- (void)hideRecoveryAlert;
- (void)showRecoveryFailAlert;
- (BOOL)validateEmail:(NSString *)candidate;

@end
