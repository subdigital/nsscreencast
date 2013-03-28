// ----------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// ----------------------------------------------------------------------------
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>
#import "MSClient.h"
#import "MSLoginController.h"
#import "MSLoginView.h"


#pragma mark * MSLogin Public Interface


// The |MSLogin| class provides the login functionality for an |MSClient|
// instance.
@interface MSLogin : NSObject


#pragma mark * Public Readonly Properties


// The client associated with this |MSLogin|.
@property (nonatomic, weak, readonly) MSClient* client;


#pragma  mark * Public Initializer Methods


// Initializes a new instance of the |MSLogin|.
-(id) initWithClient:(MSClient *)client;


#pragma  mark * Public Login Methods


// Logs in the current end user with the given provider by presenting the
// MSLoginController with the given |controller|.
-(void) loginWithProvider:(NSString *)provider
             onController:(UIViewController *)controller
                 animated:(BOOL)animated
               completion:(MSClientLoginBlock)completion;

// Returns an |MSLoginController| that can be used to log in the current
// end user with the given provider.
-(MSLoginController *) loginViewControllerWithProvider:(NSString *)provider
                                      completion:(MSClientLoginBlock)completion;

// Logs in the current end user with the given provider and the given token for
// the provider.
-(void) loginWithProvider:(NSString *)provider
                withToken:(NSDictionary *)token
               completion:(MSClientLoginBlock)completion;

@end
