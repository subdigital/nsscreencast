//
//  NSMutableURLRequest+BasicAuth.h
//  libPusher
//
//  Created by Luke Redpath on 19/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (BasicAuth)

- (void)setHTTPBasicAuthUsername:(NSString *)username password:(NSString *)password;

@end
