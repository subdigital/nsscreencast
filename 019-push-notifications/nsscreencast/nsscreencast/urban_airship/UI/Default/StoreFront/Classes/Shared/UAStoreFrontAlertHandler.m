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

#import "UAStoreFrontAlertHandler.h"
#import "UAStoreFront.h"
#import "UAUtils.h"
#import "UAStoreFrontUI.h"


@implementation UAStoreFrontAlertHandler

- (void)showConfirmRestoringAlert:(NSInteger)restoreItemsCount
                         delegate:(id)object
                  approveSelector:(SEL)approveSelector
               disapproveSelector:(SEL)disapproveSelector {
    restoreAlertDelegate = object;
    restoreAlertApproveSelector = approveSelector;
    restoreAlertDisapproveSelector = disapproveSelector;

    if (restoreItemsCount == 0) {
        NSString* okStr = UA_SF_TR(@"UA_OK");
        NSString* restoreTitle = UA_SF_TR(@"UA_content_restore_title");
        NSString* restoreMsg = UA_SF_TR(@"UA_content_restore_none");

        UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:restoreTitle
                                                               message:restoreMsg
                                                              delegate:nil
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:okStr, nil];
        [restoreAlert show];
        [restoreAlert release];
    } else {
        NSString* okStr = UA_SF_TR(@"UA_OK");
        NSString* cancelStr = UA_SF_TR(@"UA_Cancel");
        NSString* restoreTitle = UA_SF_TR(@"UA_content_restore_title");
        NSString* restoreMsg = UA_SF_TR(@"UA_content_restore");

        UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:restoreTitle
                                                               message:[NSString stringWithFormat:restoreMsg,
                                                                        restoreItemsCount,
                                                                        [UAUtils pluralize: restoreItemsCount singularForm: @"item" pluralForm: @"items"],
                                                                        [UAUtils pluralize: restoreItemsCount singularForm: @"it" pluralForm: @"them"]]
                                                              delegate:self
                                                     cancelButtonTitle:cancelStr
                                                     otherButtonTitles:okStr, nil];
        [restoreAlert show];
        [restoreAlert release];
    }
}

- (void)showPaymentTransactionFailedAlert {
    NSString* okStr = UA_SF_TR(@"UA_OK");
    NSString* purchaseErrorTitle = UA_SF_TR(@"UA_purchase_error_title");
    NSString* purchaseError = UA_SF_TR(@"UA_purchase_error");

    UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle:purchaseErrorTitle
                                                           message:purchaseError
                                                          delegate:nil
                                                 cancelButtonTitle:okStr
                                                 otherButtonTitles:nil];
    [failureAlert show];
    [failureAlert release];
}

- (void)showReceiptVerifyFailedAlert {
    NSString* okStr = UA_SF_TR(@"UA_OK");
    NSString* verificationErrorTitle = UA_SF_TR(@"UA_receipt_verification_failure_title");
    NSString* verificationError = UA_SF_TR(@"UA_receipt_verification_failure");

    UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle: verificationErrorTitle
                                                           message: verificationError
                                                          delegate: nil
                                                 cancelButtonTitle: okStr
                                                 otherButtonTitles: nil];
    [failureAlert show];
    [failureAlert release];
}

- (void)showDownloadContentFailedAlert {
    NSString* okStr = UA_SF_TR(@"UA_OK");
    NSString* downloadingErrorTitle = UA_SF_TR(@"UA_download_content_failure_title");
    NSString* downloadingError = UA_SF_TR(@"UA_download_content_failure");

    UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle: downloadingErrorTitle
                                                           message: downloadingError
                                                          delegate: nil
                                                 cancelButtonTitle: okStr
                                                 otherButtonTitles: nil];
    [failureAlert show];
    [failureAlert release];
}

- (void)showDecompressContentFailedAlert {
    NSString *okStr = UA_SF_TR(@"UA_OK");
    NSString *decompressErrorTitle = UA_SF_TR(@"UA_decompress_failure_title");
    NSString *decompressError = UA_SF_TR(@"UA_decompress_failure");
    
    UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle: decompressErrorTitle
                                                           message: decompressError
                                                          delegate: nil
                                                 cancelButtonTitle: okStr
                                                 otherButtonTitles: nil];
    [failureAlert show];
    [failureAlert release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (restoreAlertDelegate && restoreAlertApproveSelector) {
            [restoreAlertDelegate performSelector:restoreAlertApproveSelector];
        }
    } else {
        if (restoreAlertDelegate && restoreAlertDisapproveSelector) {
            [restoreAlertDelegate performSelector:restoreAlertDisapproveSelector];
        }
    }
}

@end
