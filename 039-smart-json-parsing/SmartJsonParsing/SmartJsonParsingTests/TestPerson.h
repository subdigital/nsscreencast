//
//  TestPerson.h
//  SmartJsonParsing
//
//  Created by Ben Scheirman on 10/22/12.
//  Copyright (c) 2012 NSScreencast. All rights reserved.
//

#import "JSONObject.h"

@interface TestPerson : JSONObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

@end
