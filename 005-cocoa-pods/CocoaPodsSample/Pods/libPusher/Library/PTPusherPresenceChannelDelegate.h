//
//  PTPusherPresenceChannelDelegate.h
//  libPusher
//
//  Created by Luke Redpath on 14/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTPusherPresenceChannel;

@protocol PTPusherPresenceChannelDelegate <NSObject>

/** Notifies the delegate that the presence channel subscribed successfully.
 
 Whenever you subscribe to a presence channel, a list of current subscribers will be returned by Pusher.
 
 The list will be an array of member IDs. Further metadata can be obtained by asking the channel object
 for information about a particular member using `-[PTPusherChannel infoForMemberWithID:]`.
 
 @param channel The presence channel that was subscribed to.
 @param members The current members subscribed to the channel.
 */
- (void)presenceChannel:(PTPusherPresenceChannel *)channel didSubscribeWithMemberList:(NSArray *)members;

/** Notifies the delegate that a new member subscribed to the presence channel.

 The member info can contain arbitrary user data returned by the authorization server.
 
 @param channel The presence channel that was subscribed to.
 @param memberID The ID for the new member.
 @param memberInfo The custom user data for the new member.
 */
- (void)presenceChannel:(PTPusherPresenceChannel *)channel memberAddedWithID:(NSString *)memberID memberInfo:(NSDictionary *)memberInfo;

/** Notifies the delegate that a member subscribed to the presence channel has unsubscribed.
 
 The member data can contain arbitrary user data returned by the authorization server.
 
 @param channel The presence channel that was subscribed to.
 @param memberID The ID of the member removed.
 @param index The internal index of the member (depends on the order joined/left or returned in the server member list)
 */
- (void)presenceChannel:(PTPusherPresenceChannel *)channel memberRemovedWithID:(NSString *)memberID atIndex:(NSInteger)index;

@end
