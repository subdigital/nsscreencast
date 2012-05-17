//
//  ViewController.m
//  KVOFun
//
//  Created by Ben Scheirman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@property (nonatomic, strong) Person *person;

@end

static void *kBackgroundColorObservationContext = &kBackgroundColorObservationContext;
static void *kPersonFirstNameObservationContext = &kPersonFirstNameObservationContext;

@implementation ViewController

@synthesize label = _label;
@synthesize person = _person;

- (UIColor *)colorForTag:(NSInteger)tag {
    switch (tag) {
        case ViewColorRed:
            return [UIColor redColor];
            
        case ViewColorGreen:
            return [UIColor greenColor];
            
        case ViewColorBlue:
            return [UIColor blueColor];
            
        default:
            return [UIColor lightGrayColor];
    }
}

- (IBAction)changeColor:(id)sender {
    self.view.backgroundColor = [self colorForTag:[sender tag]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.person = [Person new];
    
    [self.person addObserver:self
                  forKeyPath:@"name"
                     options:NSKeyValueObservingOptionOld
                     context:kPersonFirstNameObservationContext];
    
    self.person.name = @"Charlie";

    [self.view addObserver:self
                forKeyPath:@"backgroundColor"
                   options:NSKeyValueObservingOptionNew
                   context:kBackgroundColorObservationContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kBackgroundColorObservationContext) {
        
        UIColor *bgColor = self.view.backgroundColor;
        
        if ([bgColor isEqual:[UIColor redColor]]) {
            self.label.textColor = [UIColor whiteColor];
        } else if ([bgColor isEqual:[UIColor blueColor]]) {
            self.label.textColor = [UIColor yellowColor];
        } else {
            self.label.textColor = [UIColor blueColor];
        }
    } else if (context == kPersonFirstNameObservationContext) {
        
        NSLog(@"Person name changed from %@ to %@", 
              [change objectForKey:NSKeyValueChangeOldKey],
              self.person.name);
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.label = nil;
    
    [self.view removeObserver:self forKeyPath:@"backgroundColor"];
    [self.person removeObserver:self forKeyPath:@"name"];
}

- (void)dealloc {
    [self.view removeObserver:self forKeyPath:@"backgroundColor"];
    [self.person removeObserver:self forKeyPath:@"name"];
}

@end
