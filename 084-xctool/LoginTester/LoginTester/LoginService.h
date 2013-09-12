//
//  LoginService.h
//  LoginTester
//
//  Created by ben on 8/25/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^LoginServiceCompletionBlock)(BOOL isValid);

@interface LoginService : NSObject

- (void)verifyUsername:(NSString *)username
              password:(NSString *)password
            completion:(LoginServiceCompletionBlock)block;

@end
