//
//  FKLVenue.h
//  WhatsAround
//
//  Created by ben on 4/23/13.
//  Copyright (c) 2013 NSScreencast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSQVenue : NSObject

@property (nonatomic, copy) NSString *venueId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, copy) NSString *country;

+ (id)venueWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
