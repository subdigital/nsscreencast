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
    
    if ([[url scheme] isEqualToString:@"wordrev"]) {
        // wordrev://foo
        NSString *word = [url host];
        word = [word stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *reversed = [self reverseWord:word];
        
        [self displayWord:reversed];
        return YES;
    } else if ([[url scheme] isEqualToString:@"x-callback-wordrev"]) {
        // x-callback-wordrev://x-callback-url?x-source=..&x-success=..&x-error=..&x-cancel&word=foo
        NSString *query = [url query];
        query = [query stringByReplacingOccurrencesOfString:@"?" withString:@""];
        NSArray *paramValues = [query componentsSeparatedByString:@"&"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [paramValues enumerateObjectsUsingBlock:^(NSString *paramValue, NSUInteger idx, BOOL *stop) {
            NSArray *parts = [paramValue componentsSeparatedByString:@"="];
            NSString *key = [parts firstObject];
            NSString *value = [parts lastObject];
            params[key] = value;
        }];
        
        NSString *word = params[@"word"];
        word = [word stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *reversed = [self reverseWord:word];
        
        NSString *urlString = [NSString stringWithFormat:@"%@?word=%@", params[@"x-success"], [reversed stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *callbackURL = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:callbackURL];
        
        return YES;
    }
    
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
