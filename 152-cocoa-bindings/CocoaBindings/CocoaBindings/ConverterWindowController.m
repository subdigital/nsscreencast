//
//  ConverterWindowController.m
//  CocoaBindings
//
//  Created by Ben Scheirman on 1/13/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

#import "ConverterWindowController.h"

@implementation ConverterWindowController

- (id)init {
    return [super initWithWindowNibName:@"ConverterWindowController"];
}

- (id)initWithWindowNibName:(NSString *)windowNibName {
    NSLog(@"Cannot call initWithWindowName: directly");
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)awakeFromNib {
    self.converter.fahrenheit = 32;
}

@end
