//
//  AppDelegate.m
//  CocoaBindings
//
//  Created by Ben Scheirman on 1/13/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

#import "AppDelegate.h"
#import "ConverterWindowController.h"

@interface AppDelegate ()

@property (nonatomic, strong) ConverterWindowController *windowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.windowController = [[ConverterWindowController alloc] init];
    [self.windowController showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
