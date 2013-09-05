//
//  AlertViewProvider.h
//  LoginTester
//
//  Created by ben on 8/25/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertViewProvider : NSObject

- (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message;

@end
