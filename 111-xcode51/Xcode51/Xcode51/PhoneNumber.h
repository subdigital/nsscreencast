//
//  PhoneNumber.h
//  Xcode51
//
//  Created by ben on 3/10/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneNumber : NSObject

@property (nonatomic, copy) NSString *areaCode;
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *suffix;

- (instancetype)initWithString:(NSString *)phoneNumberString;

@end
