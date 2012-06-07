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

#import "UAInbox.h"
#import "UAInboxMessageViewController.h"
#import "UAInboxUI.h"
#import "UAInboxMessageList.h"

#import "UAUtils.h"

#define kMessageUp 0
#define kMessageDown 1

@interface UAInboxMessageViewController ()

- (void)refreshHeader;
- (void)updateMessageNavButtons;

@property (nonatomic, retain) UIActivityIndicatorView* activity;
@property (nonatomic, retain) UIView* statusBar;
@property (nonatomic, retain) UIView* statusBarTitle;
@property (nonatomic, retain) UISegmentedControl* messageNav;

@end

@implementation UAInboxMessageViewController

@synthesize webView;
@synthesize activity;
@synthesize statusBar;
@synthesize statusBarTitle;
@synthesize messageNav;
@synthesize message;
@synthesize shouldShowAlerts;

- (void)dealloc {
    [[UAInbox shared].messageList removeObserver:self];
    RELEASE_SAFELY(message);
    RELEASE_SAFELY(webView);
    RELEASE_SAFELY(activity);
    RELEASE_SAFELY(statusBar);
    RELEASE_SAFELY(statusBarTitle);
    RELEASE_SAFELY(messageNav);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    if (self = [super initWithNibName:nibName bundle:nibBundle]) {
        
        [[UAInbox shared].messageList addObserver:self];
        
        self.title = UA_INBOX_TR(@"UA_Message");

        // "Segmented" up/down control to the right
        UISegmentedControl *segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                                                 [NSArray arrayWithObjects:
                                                  [UIImage imageNamed:@"up.png"],
                                                  [UIImage imageNamed:@"down.png"],
                                                  nil]] autorelease];
        [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        segmentedControl.frame = CGRectMake(0, 0, 90, 30);
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentedControl.momentary = YES;
        self.messageNav = segmentedControl;

        UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
        self.navigationItem.rightBarButtonItem = segmentBarItem;
        [segmentBarItem release];

        [webView setDataDetectorTypes:UIDataDetectorTypeAll];
        
        self.shouldShowAlerts = YES;
    }

    return self;
}

- (void)viewDidLoad {
    int index = [[UAInbox shared].messageList indexOfMessage:message];

    // IBOutlet(webView etc) alloc memory when viewDidLoad, so we need to Reload message.
    [self loadMessageAtIndex:index];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
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


#pragma mark -
#pragma mark UI

- (void)refreshHeader {
    int count = [[UAInbox shared].messageList messageCount];
    int index = [[UAInbox shared].messageList indexOfMessage:message];

    if (index >= 0 && index < count) {
        self.title = [NSString stringWithFormat: @"%d %@ %d", index+1, UA_INBOX_TR(@"UA_Of"), count];
    } else {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        statusBar.hidden = YES;
        self.title = @"";
    }

    [self updateMessageNavButtons];
}

- (void)loadMessageForID:(NSString *)mid {
    UAInboxMessage *msg = [[UAInbox shared].messageList messageForID:mid];
    if (msg == nil) {
        UALOG(@"Can not find message with ID: %@", mid);
        return;
    }

    [self loadMessageAtIndex:[[UAInbox shared].messageList indexOfMessage:msg]];
}

- (void)loadMessageAtIndex:(int)index {
    self.message = [[UAInbox shared].messageList messageAtIndex:index];
    if (self.message == nil) {
        UALOG(@"Can not find message with index: %d", index);
        return;
    }

    [self refreshHeader];

    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL: message.messageBodyURL];
    
    [requestObj setTimeoutInterval:5];
    
    NSString *auth = [UAUtils userAuthHeaderString];
    [requestObj setValue:auth forHTTPHeaderField:@"Authorization"];
    
    [webView stopLoading];
    [webView loadRequest:requestObj];
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

- (void)populateJavascriptEnvironment {
    
    // This will inject the current device orientation
    // Note that face up and face down orientations will be ignored as this
    // casts a device orientation to an interface orientation
    [self willRotateToInterfaceOrientation:(UIInterfaceOrientation)[[UIDevice currentDevice] orientation] duration:0];
    
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

- (void)webViewDidStartLoad:(UIWebView *)wv {
    [statusBar setHidden: NO];
    [activity startAnimating];
    statusBarTitle.text = message.title;
    
    [self populateJavascriptEnvironment];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
    [statusBar setHidden: YES];
    [activity stopAnimating];

    // Mark message as read after it has finished loading
    if(message.unread) {
        [message markAsRead];
    }
    
    [self injectViewportFix];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    [statusBar setHidden: YES];
    [activity stopAnimating];

    if (error.code == NSURLErrorCancelled)
        return;
    UALOG(@"Failed to load message: %@", error);
    
    if (shouldShowAlerts) {
        
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle:UA_INBOX_TR(@"UA_Ooops")
                                                            message:UA_INBOX_TR(@"UA_Error_Fetching_Message")
                                                           delegate:self
                                                  cancelButtonTitle:UA_INBOX_TR(@"UA_OK")
                                                  otherButtonTitles:nil];
        [someError show];
        [someError release];
    }
}

#pragma mark Message Nav

- (IBAction)segmentAction:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    int index = [[UAInbox shared].messageList indexOfMessage:message];

    if(segmentedControl.selectedSegmentIndex == kMessageUp) {
        [self loadMessageAtIndex:index-1];
    } else if(segmentedControl.selectedSegmentIndex == kMessageDown) {
        [self loadMessageAtIndex:index+1];
    }
}

- (void)updateMessageNavButtons {
    int index = [[UAInbox shared].messageList indexOfMessage:message];

    if (message == nil || index == NSNotFound) {
        [messageNav setEnabled: NO forSegmentAtIndex: kMessageUp];
        [messageNav setEnabled: NO forSegmentAtIndex: kMessageDown];
    } else {
        if(index <= 0) {
            [messageNav setEnabled: NO forSegmentAtIndex: kMessageUp];
        } else {
            [messageNav setEnabled: YES forSegmentAtIndex: kMessageUp];
        }
        if(index >= [[UAInbox shared].messageList messageCount] - 1) {
            [messageNav setEnabled: NO forSegmentAtIndex: kMessageDown];
        } else {
            [messageNav setEnabled: YES forSegmentAtIndex: kMessageDown];
        }
    }

    UALOG(@"update nav %d, of %d", index, [[UAInbox shared].messageList messageCount]);
}

#pragma mark UAInboxMessageListObserver

- (void)messageListLoaded {
    [self refreshHeader];
}

@end
