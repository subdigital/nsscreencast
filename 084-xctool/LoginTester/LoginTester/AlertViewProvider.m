//
//  AlertViewProvider.m
//  LoginTester
//
//  Created by ben on 8/25/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import "AlertViewProvider.h"

@implementation AlertViewProvider

- (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message {
    return [[UIAlertView alloc] initWithTitle:title
                                      message:message
                                     delegate:nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];
}

@end
