//
//  NSMutableURLRequest+BasicAuth.m
//  libPusher
//
//  Created by Luke Redpath on 19/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "NSMutableURLRequest+BasicAuth.h"
#import "NSData+Base64.h"


@implementation NSMutableURLRequest (BasicAuth)

- (void)setHTTPBasicAuthUsername:(NSString *)username password:(NSString *)password
{
  NSString *authString = [NSString stringWithFormat:@"%@:%@", username, password];
  NSData *authData = [authString dataUsingEncoding:NSASCIIStringEncoding];
  [self setValue:[NSString stringWithFormat:@"Basic %@", [authData base64EncodedString]] forHTTPHeaderField:@"Authorization"];
}

@end
