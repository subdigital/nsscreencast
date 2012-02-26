# libPusher, an Objective-C client for Pusher

[Pusher](http://pusherapp.com/) is a hosted service that sits between your web application and the browser that lets you deliver events in real-time using HTML5 WebSockets.

This project was borne out of the idea that a web browser doesn't have to be the only client that receives your web app's real-time notifications. Why couldn't your iPhone, iPad or Mac OSX app receive real-time notifications either?

Apple provides its own push notification service which is great for getting alert-type notifications to your app's users whether or not they are using the app, but for real-time updates to data whilst they are using your app, hooking into your web app's existing event-dispatch mechanism is far less hassle (and is great if you want to be able to interact with other web services that might not have access to the APNS).

## Update: August 2011

A large update was made to this library in August 2011 that is not backwards compatible with previous-versions of this library. Users are advised to take the time to update their code to use the new API, which now mirrors more closely the Pusher Javascript API and will be more stable going forwards.

The major changes are:

* Re-architected the core API to bring it in line with the Javascript API.
* Support multiple channels over a single connection.
* Added support for private and presence channels.
* Added block-support for event callbacks.
* Extracted the wrapper for the Pusher REST API into a standalone component.
* Dropped support for iOS 3.0

## Installation instructions

Detailed installation instructions can be found [in the wiki](https://github.com/lukeredpath/libPusher/wiki/Adding-libPusher-to-your-project).

## Getting started

The libPusher API mirrors the [Pusher Javascript client](http://pusher.com/docs/client_api_guide) as closely as possible, with some allowances for Objective-C conventions. In particular, whilst the Javascript client uses event binding for all event handling, where events are pre-defined, libPusher uses the standard Cocoa delegation pattern.

[Online API Documentation](http://lukeredpath.github.com/libPusher/)

### Creating a new connection

Establishing a connection to Pusher is as simple as passing in your API key and a delegate to one of the built-in convenience factory methods:

```objc
PTPusher *client = [PTPusher pusherWithKey:@"YOUR-API-KEY" delegate:self];
```

When calling the above method, the connection will be established immediately. If you want to defer connection, you can do so:

```objc
PTPusher *client = [PTPusher pusherWithKey:@"YOUR-API-KEY" connectAutomatically:NO];
```

You can then connect when you are ready by calling `connect`.

It is recommend you assign a delegate to the Pusher client as this will enable you to be notified when significant connection events happen such as connection errors, disconnects and retries.

### Binding to events

Once you have created an instance of the Pusher client, you can set up event bindings; there is no need to wait for the connection to be established.

When you bind to events on the client, you will receive all events with that name, regardless of the channel from which they originated.

There are two ways of binding to individual events; using the standard Cocoa target/action mechanism, or using blocks. Use whatever makes sense within the context of your application.

Binding to events using target/action:

```objc
[client bindToEventNamed:@"something-happened" target:self action:@selector(handleEvent:)];
```

Binding to events using blocks:

```objc
[client bindToEventNamed:@"something-happened" handleWithBlock:^(PTPusherEvent *event) {
  // do something with event
}];
```

## Working with channels

Channels are a way of filtering the events you want your application to receive. In addition, private and presence channels can be used to control access to events and in the case of presence channels, see who else is subscribing to events. For more information on channels, [see the Pusher documentation](http://pusher.com/docs/client_api_guide/client_channels).

### Subscribing and unsubscribing

Channels of any type can be subscribed to using the method `subscribeToChannelNamed:`. When subscribing to private or presence channels, it's important to remember to add the appropriate channel name prefix.

You do not need to wait for the client to establish a connection before subscribing; you can subscribe immediately and any subscriptions will be created once the connection has connected.

```objc
// subscribe to public channels
PTPusherChannel *channel = [client subscribeToChannelNamed:@"my-public-channel"];

// subscribe to private or presence channels with the appropriate prefix
PTPusherChannel *private = [client subscribeToChannelNamed:@"private-channel"];
PTPusherChannel *presence = [client subscribeToChannelNamed:@"presence-channel"];
```
As a convenience, two methods are provided specifically for subscribing to private and presence channels. These methods will add the appropriate prefix to the channel name for you and return a channel casted to the correct PTPusherChannel sub-class. You can also set a presence delegate for presence channels using this API.

```objc
// subscribe to private channel, private- prefix added automatically
PTPusherPrivateChannel *private = [client subscribeToPrivateChannelNamed:@"demo"];

// subscribe to presence channel with a delegate, presence- prefix added automatically
PTPusherPresenceChannel *presence = [client subscribeToPresenceChannelNamed:@"chat" delegate:self];
```
Any channel that has been previously subscribed to can be retrieved (without re-subscribing) using the `channelNamed:` method. You can unsubscribe a channel by calling `unsubscribeFromChannel:`.

```objc
// get a reference to a channel we have already subscribed to
PTPusherChannel *channel = [client channelNamed:@"my-channel"];

// now unsubscribe from it
[client unsubscribeFromChannel:channel];
```

### Channel authorisation

Private and presence channels require server-side authorisation before they can connect. Because the Javascript client library runs in the browser, it assumes the presence of an existing server-side session and simply makes an AJAX POST to the server. The server then uses the existing server session cookie to authorise the subscription request.

When using libPusher in your iOS apps, there is no existing session, so you will need an alternative means of authenticating a user; possible means of authentication could be HTTP Basic Authentication or some kind of token-based authentication.

In order to connect to a private or presence channel, you first need to configure your server authorisation URL.

```objc
pusher.authorizationURL = [NSURL URLWithString:@"http://www.yourserver.com/authorise"];
```

When you attempt to connect to a private or presence channel, libPusher will make a form-encoded POST request to the above URL, passing along the socket ID and channel name as parameters. Prior to sending the request, the Pusher delegate will be notified, passing in the NSMutableURLRequest instance that will be sent.

It's at this point that you can configure the request to handle whatever authentication mechanism you are using. In this example, we simply set a custom header with a token which the server will use to authenticate the user before proceeding with authorisation.

```objc
- (void)pusher:(PTPusher *)pusher willAuthorizeChannelWithRequest:(NSMutableURLRequest *)request
{
  [request setValue:@"some-authentication-token" forHTTPHeaderField:@"X-MyCustom-AuthTokenHeader"];
}
```

### Binding to channel events

Binding to events on channels works in exactly the same way as binding to client events; the only difference is that you will only receive events with that are associated with that channel.

```objc
// subscribe to the channel
PTPusherChannel *channel = [client subscribeToChannelNamed:@"demo"];

// now bind to some events on that channel
[channel bindToEventNamed:@"channel-event" handleWithBlock:^(PTPusherEvent *channelEvent) {
  // do something with channel event
}];
```

## Binding to all events

Unlike the Javascript client, libPusher does not provide an explicit API for binding to all events from a client or channel. Instead, libPusher will publish a `NSNotification` for every event received. You can subscribe to all events for a client or channel by adding a notification observer.

```objc
// bind to all events received by the client
[[NSNotificationCenter defaultCenter] 
          addObserver:self 
             selector:@selector(didReceiveEventNotification:) 
                 name:PTPusherEventReceivedNotification 
               object:client];
               
// bind to all events on a specific channel
PTPusherChannel *channel = [client channelNamed:@"some-channel"];

[[NSNotificationCenter defaultCenter] 
          addObserver:self 
             selector:@selector(didReceiveChannelEventNotification:) 
                 name:PTPusherEventReceivedNotification 
               object:channel];
```

The event can be retrieved in your callback from the notification's `userInfo` dictionary. The notification's `object` will be either the client or channel from which the event originated.

```objc
- (void)didReceiveEventNotification:(NSNotification *)note
{
  PTPusherEvent *event = [note.userInfo objectForKey:PTPusherEventUserInfoKey];
  // do something with event
}
```

## Handling network connectivity errors and disconnects

The nature of a mobile device is that connections will come and go. There are a number of things you can do do ensure that your Pusher connection remains active for as long as you have a network connection and reconnects after network connectivity has been re-established.

The following examples use Apple's Reachability class (version 2.2) to check the network reachability status. Apple recommends that in most circumstances, you do not do any pre-flight checks and simply try and open a connection. This example follows this advice.

You can configure libPusher to automatically try and re-connect if it disconnects or it initially fails to connect.

```objc
PTPusher *client = [PTPusher pusherWithKey:@"YOUR-API-KEY" delegate:self];
client.reconnectAutomatically = YES;
client.reconnectDelay = 30; // defaults to 5 seconds
```

What you don't want to do is keep on blindly trying to reconnect if there is no available network and therefore no possible way a connection could be successful. You should implement the `PTPusherDelegate` methods `pusher:connectionDidDisconnect:` and `pusher:connection:didFailWithError:`.

```objc
- (void)pusher:(PTPusher *)client connectionDidDisconnect:(PTPusherConnection *)connection
{
  Reachability *reachability = [Reachability reachabilityForInternetConnection];
  
  if ([reachability currentReachabilityStatus] == NotReachable) {
    // there is no point in trying to reconnect at this point
    client.reconnectAutomatically = NO;
    
    // start observing the reachability status to see when we come back online
    [[NSNotificationCenter defaultCenter] 
          addObserver:self 
             selector:@selector(reachabilityChanged:) 
                 name:kReachabilityChangedNotification]
               object:reachability];
               
    [reachability startNotifier];
  }
}
```

The implementation of `pusher:connection:didFailWithError:` will look similar to the above although you may wish to do some further checking of the error.

Now you simply need to wait for the network to become reachable again; it's no guarantee that you will be able to establish a connection but it is an indicator that it would be reasonable to try again.

```objc
- (void)reachabilityChanged:(NSNotification *)note
{
  Reachability *reachability = note.object;
  
  if ([reachability currentReachabilityStatus] != NotReachable) {
    // we seem to have some kind of network reachability, so try again
    PTPusher *pusher = <# get the pusher instance #>
    [pusher connect];
    
    // we can stop observing reachability changes now
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [reachability stopNotifier];
    
    // re-enable auto-reconnect
    pusher.reconnectAutomatically = YES;
  }
}
```
Finally, you may prefer to not turn on automatic reconnection immediately, but instead wait until you've successfully connected. You could do this by implementing the `pusher:connectionDidConnect:` delegate method:

```objc
- (void)pusher:(PTPusher *)client connectionDidConnect:(PTPusherConnection *)connection
{
  client.reconnectAutomatically = YES;
}
```

Doing it this way means you do not need to re-enable auto-reconnect in your Reachability notification handler as it will happen automatically once you have connected.

If Pusher disconnects but Reachability indicates that the network is reachable, it is possible that there is a problem with the Pusher service. In this situation, you would be advised to simply allow libPusher to try and reconnect automatically (if you have enabled this). 

You may want to implement the `pusher:connectionWillReconnect:afterDelay:` delegate method and keep track of the number of retry attempts and gradually back off your retry attempts by increasing the reconnect delay after a number of retry attempts have failed. This stops you from constantly trying to connect to Pusher while it is experience issues.

## Credits

PusherTouch uses the [ZTWebSocket](http://github.com/openresearch/zimt) library by [OpenResearch](http://github.com/openresearch), without which I probably wouldn't have got anywhere.

For more information about Pusher, visit [the website](http://pusherapp.com).

## License

All code is licensed under the MIT license. See the LICENSE file for more details.
