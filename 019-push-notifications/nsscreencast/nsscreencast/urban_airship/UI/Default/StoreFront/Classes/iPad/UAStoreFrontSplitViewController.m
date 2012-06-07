/*
 Copyright 2009-2012 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UAStoreFrontSplitViewController.h"
#import "UAStoreFrontiPadViewController.h"
#import "UAProductDetailiPadViewController.h"
#import <objc/runtime.h>


@implementation UIViewController (__UISplitViewControllerCompatible)

- (void)UAWillAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                           duration:(NSTimeInterval)duration {

    CGFloat statusBarOffset = [UIApplication sharedApplication].statusBarHidden ? 0 : 20;
    CGRect masterFrame, detailFrame;
    CGFloat margin = 1;

    /* TODO: This code is temporary in order to support Potrait splitViewController display properly
        - If apple every support this, we should roll this code back
        - If the screen resolution ever changes we should update these card coded values
     */

    float width1 = 320;
    float width2 = 320;

    float systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion >= 4.2f) {
        width1 = 768;
        width2 = 1024;
    }

    //only handle the interface orientation of portrait mode
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        masterFrame = CGRectMake(0, 0, width1, 1024 - statusBarOffset);
        detailFrame = CGRectMake(320 + margin, 0, 768 - 320 - margin, 1024 - statusBarOffset);
    } else {
        masterFrame = CGRectMake(0, 0, width2, 768 - statusBarOffset);
        detailFrame = CGRectMake(320 + margin, 0, 1024 - 320 - margin, 768 - statusBarOffset);
    }

    UIViewController *con0 = [[self performSelector:@selector(viewControllers)] objectAtIndex:0];
    UIViewController *con1 = [[self performSelector:@selector(viewControllers)] objectAtIndex:1];

    con0.view.frame = masterFrame;
    con1.view.frame = detailFrame;
}

@end


static void exchangeImp() {
    Method newMethod = class_getInstanceMethod(NSClassFromString(@"UIViewController"),
                                               @selector(UAWillAnimateRotationToInterfaceOrientation:duration:));
    Method oldMethod = class_getInstanceMethod(NSClassFromString(@"UISplitViewController"),
                                               @selector(willAnimateRotationToInterfaceOrientation:duration:));

    // This function will swap the selector calls for the two above functions everytime it is called
    // currently this will be invoked in viewWillAppear and viewWillDisappear

    method_exchangeImplementations(oldMethod, newMethod);
}

static void restoreImp() {
    Method newMethod = class_getInstanceMethod(NSClassFromString(@"UIViewController"),
                                               @selector(UAWillAnimateRotationToInterfaceOrientation:duration:));
    Method oldMethod = class_getInstanceMethod(NSClassFromString(@"UISplitViewController"),
                                               @selector(willAnimateRotationToInterfaceOrientation:duration:));

    // This function will swap the selector calls for the two above functions everytime it is called
    // currently this will be invoked in viewWillAppear and viewWillDisappear

    method_exchangeImplementations(newMethod, oldMethod);
}


@implementation UAStoreFrontSplitViewController

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200

- (void)dealloc {
    RELEASE_SAFELY(masterViewController);
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        masterViewController = [[UAStoreFrontiPadViewController alloc]
                                initWithNibName:@"UAStoreFrontiPad" bundle:nil];

        UINavigationController *navControllerForMasterViewController = [[UINavigationController alloc]
                                                initWithRootViewController:masterViewController];
        UINavigationController *navControllerForDetailViewController = [[UINavigationController alloc]
                                                initWithRootViewController:masterViewController.detailViewController];

        splitViewController = [[NSClassFromString(@"UISplitViewController") alloc] init];

        [splitViewController setValue:[NSNumber numberWithInt:0] forKey:@"hidesMasterViewInPortrait"];

        [splitViewController performSelector:@selector(setViewControllers:)
                                  withObject:[NSArray arrayWithObjects:navControllerForMasterViewController,
                                               navControllerForDetailViewController, nil]];
        
        [navControllerForMasterViewController release];
        [navControllerForDetailViewController release];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    // Change to custom Layout handling
    exchangeImp();
    [splitViewController viewWillAppear:animated];
    [splitViewController willAnimateRotationToInterfaceOrientation:
     [UIApplication sharedApplication].statusBarOrientation duration:0];
}

- (void)viewWillDisappear:(BOOL)animated {
    // Put back default imp
    restoreImp();
}

#pragma mark -
#pragma mark Message Forwarding

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([splitViewController respondsToSelector:[invocation selector]])
        [invocation invokeWithTarget:splitViewController];
    else
        [super forwardInvocation:invocation];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ( [super respondsToSelector:aSelector] )
        return YES;
    else if ([splitViewController respondsToSelector:aSelector]) {
        return YES;
    }
    return NO;
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        signature = [splitViewController methodSignatureForSelector:selector];
    }
    return signature;
}

#endif
#pragma mark -

- (UAStoreFrontViewController *)productListViewController {
    return masterViewController;
}

@end