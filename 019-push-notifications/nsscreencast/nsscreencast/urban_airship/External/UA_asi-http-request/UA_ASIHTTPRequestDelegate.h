//
//  ASIHTTPRequestDelegate.h
//  Part of ASIHTTPRequest -> http://allseeing-i.com/ASIHTTPRequest
//
//  Created by Ben Copsey on 13/04/2010.
//  Copyright 2010 All-Seeing Interactive. All rights reserved.
//

@class UA_ASIHTTPRequest;

@protocol UA_ASIHTTPRequestDelegate <NSObject>

@optional

// These are the default delegate methods for request status
// You can use different ones by setting didStartSelector / didFinishSelector / didFailSelector
- (void)requestStarted:(UA_ASIHTTPRequest *)request;
- (void)request:(UA_ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)request:(UA_ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL;
- (void)requestFinished:(UA_ASIHTTPRequest *)request;
- (void)requestFailed:(UA_ASIHTTPRequest *)request;
- (void)requestRedirected:(UA_ASIHTTPRequest *)request;

// When a delegate implements this method, it is expected to process all incoming data itself
// This means that responseData / responseString / downloadDestinationPath etc are ignored
// You can have the request call a different method by setting didReceiveDataSelector
- (void)request:(UA_ASIHTTPRequest *)request didReceiveData:(NSData *)data;

// If a delegate implements one of these, it will be asked to supply credentials when none are available
// The delegate can then either restart the request ([request retryUsingSuppliedCredentials]) once credentials have been set
// or cancel it ([request cancelAuthentication])
- (void)authenticationNeededForRequest:(UA_ASIHTTPRequest *)request;
- (void)proxyAuthenticationNeededForRequest:(UA_ASIHTTPRequest *)request;

@end
