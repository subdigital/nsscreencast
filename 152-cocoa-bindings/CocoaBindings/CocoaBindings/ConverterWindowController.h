//
//  ConverterWindowController.h
//  CocoaBindings
//
//  Created by Ben Scheirman on 1/13/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Converter.h"

@interface ConverterWindowController : NSWindowController

@property (nonatomic, strong) IBOutlet Converter *converter;

@end
