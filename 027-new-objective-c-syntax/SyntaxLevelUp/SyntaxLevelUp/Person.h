//
//  Person.h
//  SyntaxLevelUp
//
//  Created by Ben Scheirman on 7/29/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

- (NSString *)fullName;

@end
