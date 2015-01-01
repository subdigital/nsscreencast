//
//  HelloWindowController.m
//  HelloCocoa
//
//  Created by Ben Scheirman on 12/31/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

#import "HelloWindowController.h"
#import "HelloCocoa-swift.h"

@interface HelloWindowController ()

@property (nonatomic, strong) TodayWindowController *todayController;

@end

@implementation HelloWindowController

- (id)init {
    return [super initWithWindowNibName:@"HelloWindowController"];
}

- (id)initWithWindowNibName:(NSString *)windowNibName {
    NSLog(@"We don't support calling [%@ initWithWindowNibName:]", self.class);
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (IBAction)clickForCandyClicked:(id)sender {
    self.todayController = [TodayWindowController windowController];
    [self.todayController showWindow:self];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
