//
//  BeerInfoDataModel.h
//  BeerInfo
//
//  Created by ben on 2/3/13.
//  Copyright (c) 2013 nsscreencast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface BeerInfoDataModel : NSObject

+ (id)sharedDataModel;
- (void)setup;

@end
