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

#import "UAUser.h"

@class UAInboxMessage;

/**
 * An emum expressing the two possible batch update commands,
 * delete and mark-as-read.
 */
typedef enum {
    UABatchReadMessages,
    UABatchDeleteMessages,
} UABatchUpdateCommand;

/**
 * The primary interface to the contents of the inbox.
 * Use this class to asychronously retrieve messges from the server,
 * delete or mark messages as read, retrieve individual messages from the
 * list.
 */
@interface UAInboxMessageList : UAObservable <UAUserObserver> {
  @private
    NSMutableArray *messages;
    // If unreadCount < 0, that means the message list hasn't retrieved.
    int unreadCount;
    int nRetrieving;
    BOOL isBatchUpdating;
}

/**
 * The shared singleton accessor.
 */
+ (UAInboxMessageList *)shared;

/**
 * Teardown method.  This method is called as appropriate by the library,
 * and thus you will not oridinarlly need to call it directly.
 */
+ (void)land;

/**
 * Fetch new messages from the server.  This will result in a
 * callback to observers at [UAInboxMessageListObserver messageListWillLoad] when loading starts, 
 * and [UAInboxMessageListObserver messageListLoaded] upon completion.
 */
- (void)retrieveMessageList;

/**
 * Update the message list by marking messages as read, or deleting them.
 * This eventually will result in an asyncrhonous observer callback to
 * [UAInboxMessageListObserver batchMarkAsReadFinished],
 * [UAInboxMessageListObserver batchMarkAsReadFailed],
 * [UAInboxMessageListObserver batchDeleteFinished], or
 * [UAInboxMessageListObserver batchDeleteFailed].
 * @param command the UABatchUpdateCommand to perform.
 * @param messageIndexSet an NSIndexSet of message IDs representing the subset of the inbox to update.
 */
- (void)performBatchUpdateCommand:(UABatchUpdateCommand)command withMessageIndexSet:(NSIndexSet *)messageIndexSet;

/**
 * Returns the number of messages currently in the inbox.
 * @return The message count as an integer.
 */
- (int)messageCount;

/**
 * Returns the message associated with a particular ID.
 * @param mid The message ID as an NSString.
 * @return The associated UAInboxMessage object.
 */
- (UAInboxMessage *)messageForID:(NSString *)mid;

/**
 * Returns the message associated with a particular message list index.
 * @param index The message list index as an integer.
 * @return The associated UAInboxMessage object.
 */
- (UAInboxMessage*)messageAtIndex:(int)index;

/**
 * Returns the index of a particular message within the message list.
 * @param message The UAInboxMessage object of interest.
 * @return The index of the message as an integer.
 */
- (int)indexOfMessage:(UAInboxMessage *)message;

/**
 * The list of messages on disk as an NSMutableArray.
 */
@property(nonatomic, retain) NSMutableArray *messages;

/**
 * The number of messages that are currently unread or -1
 * if the message list is not loaded.
 */
@property(assign) int unreadCount;

/**
 * YES if a batch update is currently being performed on the message list,
 * NO otherwise.
 */
@property(assign) BOOL isBatchUpdating;

@property(readonly) BOOL isRetrieving;

@end
