//
//  ASIAuthenticationDialog.h
//  Part of ASIHTTPRequest -> http://allseeing-i.com/ASIHTTPRequest
//
//  Created by Ben Copsey on 21/08/2009.
//  Copyright 2009 All-Seeing Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class UA_ASIHTTPRequest;

typedef enum _UA_ASIAuthenticationType {
	UA_ASIStandardAuthenticationType = 0,
    UA_ASIProxyAuthenticationType = 1
} UA_ASIAuthenticationType;

@interface UA_ASIAutorotatingViewController : UIViewController
@end

@interface UA_ASIAuthenticationDialog : UA_ASIAutorotatingViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {
	UA_ASIHTTPRequest *request;
	UA_ASIAuthenticationType type;
	UITableView *tableView;
	UIViewController *presentingController;
	BOOL didEnableRotationNotifications;
}
+ (void)presentAuthenticationDialogForRequest:(UA_ASIHTTPRequest *)request;
+ (void)dismiss;

@property (retain) UA_ASIHTTPRequest *request;
@property (assign) UA_ASIAuthenticationType type;
@property (assign) BOOL didEnableRotationNotifications;
@property (retain, nonatomic) UIViewController *presentingController;
@end
