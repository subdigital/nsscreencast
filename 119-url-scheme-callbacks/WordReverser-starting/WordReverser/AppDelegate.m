//
//  AppDelegate.m
//  WordReverser
//
//  Created by ben on 4/26/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // wordrev://foo
    NSString *word = [url host];
    NSString *reversed = [self reverseWord:word];
    
    [self displayWord:reversed];
    
    
    return NO;
}

- (NSString *)reverseWord:(NSString *)word {
    NSMutableString *reversed = [NSMutableString stringWithCapacity:word.length];
    
    [word enumerateSubstringsInRange:NSMakeRange(0, word.length)
                             options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              [reversed appendString:substring];
                          }];
    return reversed;
}

- (void)displayWord:(NSString *)word {
    ViewController *vc = (ViewController *)self.window.rootViewController;
    vc.label.text = word;
}

@end
