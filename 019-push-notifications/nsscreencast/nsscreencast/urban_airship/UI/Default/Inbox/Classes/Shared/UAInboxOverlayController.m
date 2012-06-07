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

/* UAInboxOverlayController is based on MTPopupWindow
 * http://www.touch-code-magazine.com/showing-a-popup-window-in-ios-class-for-download/
 *
 * Copyright 2011 Marin Todorov. MIT license
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 * and associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute,
 * sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
 * is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or
 * substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
 * BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "UAInboxOverlayController.h"
#import "UAInboxMessage.h"
#import "UAInboxMessageList.h"
#import "UAInbox.h"
#import "UAInboxUI.h"
#import "UAUtils.h"

#import <QuartzCore/QuartzCore.h>

#define kShadeViewTag 1000

@interface UAInboxOverlayController(Private)

- (id)initWithParentViewController:(UIViewController *)parent andMessageID:(NSString*)messageID;
- (void)loadMessageAtIndex:(int)index;
- (void)loadMessageForID:(NSString *)mid;
- (void)displayWindow;
- (void)closePopupWindow;

@end

@implementation UAInboxOverlayController

@synthesize webView, message;


+ (void)showWindowInsideViewController:(UIViewController *)viewController withMessageID:(NSString *)messageID {
    [[UAInboxOverlayController alloc] initWithParentViewController:viewController andMessageID:messageID];
}


- (id)initWithParentViewController:(UIViewController *)parent andMessageID:(NSString*)messageID {
    self = [super init];
    if (self) {
        // Initialization code here.
        
        parentViewController = [parent retain];
        UIView *sview = parent.view;
        
        bgView = [[[UIView alloc] initWithFrame: sview.bounds] autorelease];
        bgView.autoresizesSubviews = YES;
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [sview addSubview: bgView];
        
        //set the frame later
        webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = NO;
        webView.delegate = self;
        
        //hack to hide the ugly webview gradient
        for (UIView* subView in [webView subviews]) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView* shadowView in [subView subviews]) {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        [shadowView setHidden:YES];
                    }
                }
            }
        }
        
        loadingIndicator = [[UABeveledLoadingIndicator indicator] retain];
                
        //required to receive orientation updates from NSNotificationCenter
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(orientationChanged:) 
                                                     name:UIDeviceOrientationDidChangeNotification object:nil];
        
        [self loadMessageForID:messageID];
        
    }
    
    return self;
}

- (void)dealloc {
    self.message = nil;
    self.webView = nil;
    [parentViewController release];
    [loadingIndicator release];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    [super dealloc];
}

- (void)loadMessageAtIndex:(int)index {
    self.message = [[UAInbox shared].messageList messageAtIndex:index];
    if (self.message == nil) {
        UALOG(@"Can not find message with index: %d", index);
        [self closePopupWindow];
        return;
    }
    
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL: message.messageBodyURL];
    NSString *auth = [UAUtils userAuthHeaderString];
    
    [requestObj setValue:auth forHTTPHeaderField:@"Authorization"];
    [requestObj setTimeoutInterval:5];
    
    [webView stopLoading];
    [webView loadRequest:requestObj];
    [self performSelector:@selector(displayWindow) withObject:nil afterDelay:0.1];
}

- (void)loadMessageForID:(NSString *)mid {
    UAInboxMessage *msg = [[UAInbox shared].messageList messageForID:mid];
    if (msg == nil) {
        UALOG(@"Can not find message with ID: %@", mid);
        [self closePopupWindow];
        return;
    }
    
    [self loadMessageAtIndex:[[UAInbox shared].messageList indexOfMessage:msg]];
}

- (BOOL)shouldTransition {
    return [UIView respondsToSelector:@selector(transitionFromView:toView:duration:options:completion:)];
}

- (void)constructWindow {
    
    //the new panel
    bigPanelView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)] autorelease];
    bigPanelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bigPanelView.autoresizesSubviews = YES;
    bigPanelView.center = CGPointMake( bgView.frame.size.width/2, bgView.frame.size.height/2);
    
    //add the window background
    UIView *background = [[[UIView alloc] initWithFrame:CGRectInset
                           (bigPanelView.frame, 15, 30)] autorelease];
    background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    background.backgroundColor = [UIColor whiteColor];
    background.layer.borderColor = [[UIColor blackColor] CGColor];
    background.layer.borderWidth = 2;
    background.center = CGPointMake(bigPanelView.frame.size.width/2, bigPanelView.frame.size.height/2);
    [bigPanelView addSubview: background];
    
    //add the web view
    int webOffset = 2;
    webView.frame = CGRectInset(background.frame, webOffset, webOffset);
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [bigPanelView addSubview: webView];
    
    [webView addSubview:loadingIndicator];
    loadingIndicator.center = CGPointMake(webView.frame.size.width/2, webView.frame.size.height/2);
    [loadingIndicator show];
    
    //add the close button
    int closeBtnOffset = 10;
    UIImage* closeBtnImg = [UIImage imageNamed:@"overlayCloseBtn.png"];
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
    [closeBtn setFrame:CGRectMake( background.frame.origin.x + background.frame.size.width - closeBtnImg.size.width - closeBtnOffset, 
                                  background.frame.origin.y ,
                                  closeBtnImg.size.width + closeBtnOffset, 
                                  closeBtnImg.size.height + closeBtnOffset)];
    [closeBtn addTarget:self action:@selector(closePopupWindow) forControlEvents:UIControlEventTouchUpInside];
    [bigPanelView addSubview: closeBtn];
    
}

-(void)displayWindow {
    
    if ([self shouldTransition]) {
        //faux view
        UIView* fauxView = [[[UIView alloc] initWithFrame: bgView.bounds] autorelease];
        fauxView.autoresizesSubviews = YES;
        fauxView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [bgView addSubview: fauxView];
        
        //animation options
        UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromRight |
        UIViewAnimationOptionAllowUserInteraction    |
        UIViewAnimationOptionBeginFromCurrentState;
        
        [self constructWindow];
        
        //run the animation
        [UIView transitionFromView:fauxView toView:bigPanelView duration:0.5 options:options completion: ^(BOOL finished) {
            
            //dim the contents behind the popup window
            UIView* shadeView = [[[UIView alloc] initWithFrame:bigPanelView.bounds] autorelease];
            shadeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            shadeView.backgroundColor = [UIColor blackColor];
            shadeView.alpha = 0.3;
            shadeView.tag = kShadeViewTag;
            [bigPanelView addSubview: shadeView];
            [bigPanelView sendSubviewToBack: shadeView];
        }];
    }
    
    else {
        [self constructWindow];
        [bgView addSubview:bigPanelView];
    }
}

- (void)onRotationChange:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if(![parentViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation]) {
        return;
    }
    
    switch (toInterfaceOrientation) {
        case UIDeviceOrientationPortrait:
            [webView stringByEvaluatingJavaScriptFromString:@"window.__defineGetter__('orientation',function(){return 0;});window.onorientationchange();"];
            break;
        case UIDeviceOrientationLandscapeLeft:
            [webView stringByEvaluatingJavaScriptFromString:@"window.__defineGetter__('orientation',function(){return 90;});window.onorientationchange();"];
            break;
        case UIDeviceOrientationLandscapeRight:
            [webView stringByEvaluatingJavaScriptFromString:@"window.__defineGetter__('orientation',function(){return -90;});window.onorientationchange();"];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            [webView stringByEvaluatingJavaScriptFromString:@"window.__defineGetter__('orientation',function(){return 180;});window.onorientationchange();"];
            break;
        default:
            break;
    }
}

- (void)orientationChanged:(NSNotification *)notification {
    // Note that face up and face down orientations will be ignored as this
    // casts a device orientation to an interface orientation
    [self onRotationChange:(UIInterfaceOrientation)[UIDevice currentDevice].orientation];
}

- (void)populateJavascriptEnvironment {
    
    // This will inject the current device orientation
    // Note that face up and face down orientations will be ignored as this
    // casts a device orientation to an interface orientation
    [self onRotationChange:(UIInterfaceOrientation)[UIDevice currentDevice].orientation];
    
    /*
     * Define and initialize our one global
     */
    NSString* js = @"var UAirship = {};";
    
    /*
     * Set the device model.
     */
    NSString *model = [UIDevice currentDevice].model;
    js = [js stringByAppendingFormat:@"UAirship.devicemodel=\"%@\";", model];
    
    /*
     * Set the UA user ID.
     */
    NSString *userID = [UAUser defaultUser].username;
    js = [js stringByAppendingFormat:@"UAirship.userID=\"%@\";", userID];
    
    /*
     * Set the current message ID.
     */
    NSString* messageID = message.messageID;
    js = [js stringByAppendingFormat:@"UAirship.messageID=\"%@\";", messageID];
    
    /*
     * Define UAirship.handleCustomURL.
     */
    js = [js stringByAppendingString:@"UAirship.invoke = function(url) { location = url; };"];
    
    /*
     * Execute the JS we just constructed.
     */
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)injectViewportFix {
    NSString *js = @"var metaTag = document.createElement('meta');"
    "metaTag.name = 'viewport';"
    "metaTag.content = 'width=device-width; initial-scale=1.0; maximum-scale=1.0;';"
    "document.getElementsByTagName('head')[0].appendChild(metaTag);";
    
    [webView stringByEvaluatingJavaScriptFromString:js];
}

/**
 * Removes the shade background and calls the finish selector
 */
- (void)closePopupWindow {
    //remove the shade
    [[bigPanelView viewWithTag: kShadeViewTag] removeFromSuperview];
    [self performSelector:@selector(finish) withObject:nil afterDelay:0.1];
    
}

/**
 * Removes child views from bigPanelView and bgView
 */
- (void)removeChildViews {
    for (UIView* child in bigPanelView.subviews) {
        [child removeFromSuperview];
    }
    for (UIView* child in bgView.subviews) {
        [child removeFromSuperview];
    }
}


/**
 * Removes all views from the hierarchy and releases self
 */
-(void)finish {
    
    if ([self shouldTransition]) {
        
        //faux view
        __block UIView* fauxView = [[UIView alloc] initWithFrame: CGRectMake(10, 10, 200, 200)];
        [bgView addSubview: fauxView];
        
        //run the animation
        UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromLeft |
        UIViewAnimationOptionAllowUserInteraction    |
        UIViewAnimationOptionBeginFromCurrentState;
        
        //hold to the bigPanelView, because it'll be removed during the animation
        [bigPanelView retain];
        
        [UIView transitionFromView:bigPanelView toView:fauxView duration:0.5 options:options completion:^(BOOL finished) {
            
            [self removeChildViews];
            [bigPanelView release];
            [bgView removeFromSuperview];
            [self release];
        }];
    }
    
    else {
        [self removeChildViews];
        [bgView removeFromSuperview];
        [self release];
    }
}


#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    
    /*
     ua://callbackArguments:withOptions:/[<arguments>][?<dictionary>]
     */
    
    if ([[url scheme] isEqualToString:@"ua"]) {
        if ((navigationType == UIWebViewNavigationTypeLinkClicked) || (navigationType == UIWebViewNavigationTypeOther)) {
            [UAInboxMessage performJSDelegate:wv url:url];
            return NO;
        }
    }
    
    // send iTunes/Phobos urls to AppStore.app
    else if ((navigationType == UIWebViewNavigationTypeLinkClicked) &&
             (([[url host] isEqualToString:@"phobos.apple.com"]) ||
              ([[url host] isEqualToString:@"itunes.apple.com"]))) {
                 
                 // TODO: set the url scheme to http, as it could be itms which will cause the store to launch twice (undesireable)
                 
                 return ![[UIApplication sharedApplication] openURL:url];
             }
    
    // send maps.google.com url or maps: to GoogleMaps.app
    else if ((navigationType == UIWebViewNavigationTypeLinkClicked) &&
             (([[url host] isEqualToString:@"maps.google.com"]) ||
              ([[url scheme] isEqualToString:@"maps"]))) {
                 
                 /* Do any special formatting here, for example:
                  
                  NSString *title = @"title";
                  float latitude = 35.4634;
                  float longitude = 9.43425;
                  int zoom = 13;
                  NSString *stringURL = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@@%1.6f,%1.6f&z=%d", title, latitude, longitude, zoom];
                  
                  */
                 
                 return ![[UIApplication sharedApplication] openURL:url];
             }
    
    // send www.youtube.com url to YouTube.app
    else if ((navigationType == UIWebViewNavigationTypeLinkClicked) &&
             ([[url host] isEqualToString:@"www.youtube.com"])) {
        return ![[UIApplication sharedApplication] openURL:url];
    }
    
    // send mailto: to Mail.app
    else if ((navigationType == UIWebViewNavigationTypeLinkClicked) && ([[url scheme] isEqualToString:@"mailto"])) {
        
        /* Do any special formatting here if you like, for example:
         
         NSString *subject = @"Message subject";
         NSString *body = @"Message body";
         NSString *address = @"address@domain.com";
         NSString *cc = @"address@domain.com";
         NSString *path = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@", address, cc, subject, body];
         NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
         
         For complex body text you may want to use CFURLCreateStringByAddingPercentEscapes.
         
         */
        
        return ![[UIApplication sharedApplication] openURL:url];
    }
    
    // send tel: to Phone.app
    else if ((navigationType == UIWebViewNavigationTypeLinkClicked) && ([[url scheme] isEqualToString:@"tel"])) {
        
        // TODO: Phone number must not contain spaces or brackets. Spaces or plus signs OK. Can add come checks here.
        
        return ![[UIApplication sharedApplication] openURL:url];
    }
    
    // send sms: to Messages.app
    else if ((navigationType == UIWebViewNavigationTypeLinkClicked) && ([[url scheme] isEqualToString:@"sms"])) {
        return ![[UIApplication sharedApplication] openURL:url];
    }
    
    // load local file and http/https webpages in webview
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)wv {
    [self populateJavascriptEnvironment];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
    [loadingIndicator hide];
    
    // Mark message as read after it has finished loading
    if(message.unread) {
        [message markAsRead];
    }

    [self injectViewportFix];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    
    [loadingIndicator hide];
    
    if (error.code == NSURLErrorCancelled)
        return;
    UALOG(@"Failed to load message: %@", error);
    UIAlertView *someError = [[UIAlertView alloc] initWithTitle:UA_INBOX_TR(@"UA_Ooops")
                                                        message:UA_INBOX_TR(@"UA_Error_Fetching_Message")
                                                       delegate:self
                                              cancelButtonTitle:UA_INBOX_TR(@"UA_OK")
                                              otherButtonTitles:nil];
    [someError show];
    [someError release];
}


@end
