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

/**
 * Implementers of this protocol will receive callbacks
 * when IAP events requiring the display of alerts occur.
 */
@protocol UAStoreFrontAlertProtocol<NSObject>
@required
/**
 * Called when an alert should be displayed that confirms a
 * restore operation.
 * @param restoreItemsCount The nubmer of items to be restored.
 * @param delegate The delegate on which to invoke selectors for approval or disapproval
 * @param approveSelector The selector to invoke when the restore is approved.
 * @param disapprovedSelector The selector to invoke when the restore is disapproved.
 */
- (void)showConfirmRestoringAlert:(NSInteger)restoreItemsCount
                         delegate:(id)object
                  approveSelector:(SEL)okSelector
               disapproveSelector:(SEL)cancelSelector;

@optional
/**
 * Called when an alert should be displayed showing that a Payment
 * transaction failed.
 */
- (void)showPaymentTransactionFailedAlert;
/**
 * Called when an alert should be displayed showing that a Receipt
 * verification failed.
 */
- (void)showReceiptVerifyFailedAlert;
/**
 * Called when an alert should be displayed showing that a content
 * download failed.
 */
- (void)showDownloadContentFailedAlert;
/**
 * Called when an alert should be displayed showing that content
 * decompression failed.
 */
- (void)showDecompressContentFailedAlert;
@end
