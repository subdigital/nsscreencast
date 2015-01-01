//
//  AppDelegate.m
//  HelloCocoa
//
//  Created by Ben Scheirman on 12/31/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "AppDelegate.h"
#import "HelloWindowController.h"

@interface AppDelegate ()

@property (nonatomic, strong) HelloWindowController *helloController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.helloController = [[HelloWindowController alloc] init];
    [self.helloController showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
