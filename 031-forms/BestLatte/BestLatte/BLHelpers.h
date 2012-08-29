//
//  BLDeviceHelpers.h
//  BestLatte
//
//  Created by Ben Scheirman on 8/28/12.
//
//

#import <Foundation/Foundation.h>

static inline BOOL IsRetina() {
    UIScreen* s = [UIScreen mainScreen];
    if ([s respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        [s respondsToSelector:@selector(scale)])
    {
        CGFloat scale = [s scale];
        return scale == 2.0;
    }
    
    return NO;
}