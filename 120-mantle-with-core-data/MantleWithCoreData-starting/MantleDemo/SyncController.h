//
//  SyncController.h
//  MantleDemo
//
//  Created by ben on 5/5/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDMPersistenceController.h"

@interface SyncController : NSObject

- (instancetype)initWithPersistenceController:(MDMPersistenceController *)persistenceController;
- (void)syncEpisodes;

@end
