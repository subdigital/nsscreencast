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
#import <StoreKit/StoreKit.h>

#import "UAObservable.h"

@class UAProduct;
@class UA_ASINetworkQueue;

@interface UAStoreKitObserver : UAObservable <SKPaymentTransactionObserver> {

  @private
    BOOL restoring;
    
    // when restoring all transactions, put the transaction into this array but
    // not download content for them. Then alert user the count, and download
    // all of them if user agree to download
    NSMutableArray *unRestoredTransactions;
}
@property (nonatomic, assign) BOOL restoring;

- (void)restoreAll;
- (void)failedTransaction:(SKPaymentTransaction *)transaction;
- (void)finishTransaction:(SKPaymentTransaction *)transaction;
- (void)finishUnknownTransaction:(SKPaymentTransaction *)transaction;
- (void)payForProduct:(SKProduct *)product;
- (UAProduct *)productFromTransaction:(SKPaymentTransaction *)transaction;


/*
 only for test
 i have to move this private method to here, caz in the test i need to rewrite it
 */
- (void)completeTransaction:(SKPaymentTransaction *)transaction;

@end
