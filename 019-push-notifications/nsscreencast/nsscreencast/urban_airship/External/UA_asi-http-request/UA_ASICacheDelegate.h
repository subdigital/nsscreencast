//
//  ASICacheDelegate.h
//  Part of ASIHTTPRequest -> http://allseeing-i.com/ASIHTTPRequest
//
//  Created by Ben Copsey on 01/05/2010.
//  Copyright 2010 All-Seeing Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UA_ASIHTTPRequest;

// Cache policies control the behaviour of a cache and how requests use the cache
// When setting a cache policy, you can use a combination of these values as a bitmask
// For example: [request setCachePolicy:UA_ASIAskServerIfModifiedCachePolicy|UA_ASIFallbackToCacheIfLoadFailsCachePolicy|UA_ASIDoNotWriteToCacheCachePolicy];
// Note that some of the behaviours below are mutally exclusive - you cannot combine UA_ASIAskServerIfModifiedWhenStaleCachePolicy and UA_ASIAskServerIfModifiedCachePolicy, for example.
typedef enum _UA_ASICachePolicy {

	// The default cache policy. When you set a request to use this, it will use the cache's defaultCachePolicy
	// UA_ASIDownloadCache's default cache policy is 'UA_ASIAskServerIfModifiedWhenStaleCachePolicy'
	UA_ASIUseDefaultCachePolicy = 0,

	// Tell the request not to read from the cache
	UA_ASIDoNotReadFromCacheCachePolicy = 1,

	// The the request not to write to the cache
	UA_ASIDoNotWriteToCacheCachePolicy = 2,

	// Ask the server if there is an updated version of this resource (using a conditional GET) ONLY when the cached data is stale
	UA_ASIAskServerIfModifiedWhenStaleCachePolicy = 4,

	// Always ask the server if there is an updated version of this resource (using a conditional GET)
	UA_ASIAskServerIfModifiedCachePolicy = 8,

	// If cached data exists, use it even if it is stale. This means requests will not talk to the server unless the resource they are requesting is not in the cache
	UA_ASIOnlyLoadIfNotCachedCachePolicy = 16,

	// If cached data exists, use it even if it is stale. If cached data does not exist, stop (will not set an error on the request)
	UA_ASIDontLoadCachePolicy = 32,

	// Specifies that cached data may be used if the request fails. If cached data is used, the request will succeed without error. Usually used in combination with other options above.
	UA_ASIFallbackToCacheIfLoadFailsCachePolicy = 64
} UA_ASICachePolicy;

// Cache storage policies control whether cached data persists between application launches (UA_ASICachePermanentlyCacheStoragePolicy) or not (UA_ASICacheForSessionDurationCacheStoragePolicy)
// Calling [UA_ASIHTTPRequest clearSession] will remove any data stored using UA_ASICacheForSessionDurationCacheStoragePolicy
typedef enum _UA_ASICacheStoragePolicy {
	UA_ASICacheForSessionDurationCacheStoragePolicy = 0,
	UA_ASICachePermanentlyCacheStoragePolicy = 1
} UA_ASICacheStoragePolicy;


@protocol UA_ASICacheDelegate <NSObject>

@required

// Should return the cache policy that will be used when requests have their cache policy set to UA_ASIUseDefaultCachePolicy
- (UA_ASICachePolicy)defaultCachePolicy;

// Returns the date a cached response should expire on. Pass a non-zero max age to specify a custom date.
- (NSDate *)expiryDateForRequest:(UA_ASIHTTPRequest *)request maxAge:(NSTimeInterval)maxAge;

// Updates cached response headers with a new expiry date. Pass a non-zero max age to specify a custom date.
- (void)updateExpiryForRequest:(UA_ASIHTTPRequest *)request maxAge:(NSTimeInterval)maxAge;

// Looks at the request's cache policy and any cached headers to determine if the cache data is still valid
- (BOOL)canUseCachedDataForRequest:(UA_ASIHTTPRequest *)request;

// Removes cached data for a particular request
- (void)removeCachedDataForRequest:(UA_ASIHTTPRequest *)request;

// Should return YES if the cache considers its cached response current for the request
// Should return NO is the data is not cached, or (for example) if the cached headers state the request should have expired
- (BOOL)isCachedDataCurrentForRequest:(UA_ASIHTTPRequest *)request;

// Should store the response for the passed request in the cache
// When a non-zero maxAge is passed, it should be used as the expiry time for the cached response
- (void)storeResponseForRequest:(UA_ASIHTTPRequest *)request maxAge:(NSTimeInterval)maxAge;

// Removes cached data for a particular url
- (void)removeCachedDataForURL:(NSURL *)url;

// Should return an NSDictionary of cached headers for the passed URL, if it is stored in the cache
- (NSDictionary *)cachedResponseHeadersForURL:(NSURL *)url;

// Should return the cached body of a response for the passed URL, if it is stored in the cache
- (NSData *)cachedResponseDataForURL:(NSURL *)url;

// Returns a path to the cached response data, if it exists
- (NSString *)pathToCachedResponseDataForURL:(NSURL *)url;

// Returns a path to the cached response headers, if they url
- (NSString *)pathToCachedResponseHeadersForURL:(NSURL *)url;

// Returns the location to use to store cached response headers for a particular request
- (NSString *)pathToStoreCachedResponseHeadersForRequest:(UA_ASIHTTPRequest *)request;

// Returns the location to use to store a cached response body for a particular request
- (NSString *)pathToStoreCachedResponseDataForRequest:(UA_ASIHTTPRequest *)request;

// Clear cached data stored for the passed storage policy
- (void)clearCachedResponsesForStoragePolicy:(UA_ASICacheStoragePolicy)cachePolicy;

@end
