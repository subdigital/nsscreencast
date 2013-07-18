//
//  main.m
//  RegexCli
//
//  Created by ben on 7/14/13.
//  Copyright (c) 2013 Fickle Bits. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSString *inputPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Input.txt"];
        NSString *input = [NSString stringWithContentsOfFile:inputPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
        
        
        
        assert(input);
        
        /* REGEX */
        NSError *regexError = nil;
        NSRegularExpression *nameRegex = [NSRegularExpression regularExpressionWithPattern:@"^Name:\\s*?(.+)"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&regexError];
        if (!nameRegex) {
            NSLog(@"REGEX ERROR: %@", regexError);
        }
        
        __block NSString *name = nil;
        [nameRegex enumerateMatchesInString:input
                                    options:0
                                      range:NSMakeRange(0, [input length])
                                 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                     if ([result numberOfRanges] > 1) {
                                         NSRange range = [result rangeAtIndex:1];
                                         name = [input substringWithRange:range];
                                     }
                                     (*stop) = YES;
                                 }];
        
        NSLog(@"Name: %@", name);
        

        /* DATA DETECTORS */
        NSError *dataDetectorError = nil;
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingAllTypes
                                                                   error:&dataDetectorError];
        if (!detector) {
            NSLog(@"ERROR with data detector: %@", dataDetectorError);
        }
        
        [detector enumerateMatchesInString:input
                                   options:0
                                     range:NSMakeRange(0, [input length])
                                usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                    for (int r=0; r < [result numberOfRanges]; r++) {
                                        NSRange range = [result rangeAtIndex:r];
                                        NSString *substring = [input substringWithRange:range];
                                        NSLog(@"Result type: %d", (int)result.resultType);
                                        NSLog(@"Match: [%@] ==> %@", NSStringFromRange(range), substring);
                                    }
                                }];

        /* LINGUISTIC TAGS */
        NSArray *tagSchemes = [NSLinguisticTagger availableTagSchemesForLanguage:@"en"];
        NSLinguisticTaggerOptions options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerJoinNames;
        NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:tagSchemes
                                                                            options:options];
        tagger.string = input;
        [tagger enumerateTagsInRange:NSMakeRange(0, [input length])
                              scheme:NSLinguisticTagSchemeNameTypeOrLexicalClass
                             options:options
                          usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
                              NSString *token = [input substringWithRange:tokenRange];
                              NSLog(@"Token: %@   (%@)", token, tag);
                          }];
    }
}

