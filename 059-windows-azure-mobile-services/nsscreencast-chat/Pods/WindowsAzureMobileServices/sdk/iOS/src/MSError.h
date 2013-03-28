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

#ifndef WindowsAzureMobileServices_MSError_h
#define WindowsAzureMobileServices_MSError_h


#pragma mark * MSErrorDomain


// The error domain for the Windows Azure Mobile Service client framework
NSString *const MSErrorDomain;


#pragma mark * UserInfo Request and Response Keys


// The key to use with the |NSError| userInfo dictionary to retrieve the request
// that was sent to the Windows Azure Mobile Service related to the error. Not
// all errors will include the request so the userInfo dicitionary may return
// nil.
NSString *const MSErrorRequestKey;

// The key to use with the |NSError| userInfo dictionary to retrieve the
// response that was returned from the Windows Azure Mobile Service related to
// the error. Not all errors will include the response so the userInfo
// dicitionary may return nil.
NSString *const MSErrorResponseKey;


#pragma mark * MSErrorCodes

// Indicates that a request to the Windows Azure Mobile Service failed because
// a nil item was used.
#define MSExpectedItemWithRequest               -1101

// Indicates that a request to the Windows Azure Mobile Service failed because
// an item without an id was used
#define MSMissingItemIdWithRequest              -1102

// Indicates that a request to the Windows Azure Mobile Service failed because
// an invalid item was used.
#define MSInvalidItemWithRequest                -1103

// Indicates that a request to the Windows Azure Mobile Service failed because
// a nil itemId was used.
#define MSExpectedItemIdWithRequest             -1104

// Indicates that a request to the Windows Azure Mobile Service failed because
// an invalid itemId was used.
#define MSInvalidItemIdWithRequest              -1105

// Indicates that a request to the Windows Azure Mobile Service failed because
// an invalid user-parameter in the query string.
#define MSInvalidUserParameterWithRequest       -1106

// Indicates that a request to the Windows Azure Mobile Service failed because
// an item with an id was used with an insert operation.
#define MSExistingItemIdWithRequest             -1107

// Indicates that the response from the Windows Azure Mobile Service did not
// inlcude an item as expected.
#define MSExpectedItemWithResponse              -1201

// Indicates that the response from the Windows Azure Mobile Service did not
// include an array of items as expected.
#define MSExpectedItemsWithResponse             -1202

// Indicates that the response from the Windows Azure Mobile Service did not
// include a total count as expected.
#define MSExpectedTotalCountWithResponse        -1203

// Indicates that the response from the Windows Azure Mobile Service did not
// have body content as expected.
#define MSExpectedBodyWithResponse              -1204

// Indicates that the response from the Windows Azure Mobile Service indicated
// there was an error but that an error message was not provided.
#define MSErrorNoMessageErrorCode               -1301

// Indicates that the response from the Windows Azure Mobile Service indicated
// there was an error and an error message was provided.
#define MSErrorMessageErrorCode                 -1302

// Indicates that a request to the Windows Azure Mobile Service failed becaus
// the |NSPredicate| used in the query could not be translated into a query
// string supported by the Windows Azure Mobile Service.
#define MSPredicateNotSupported                 -1400

// Indicates that the login operation has failed.
#define MSLoginFailed                           -1501

// Indicates that the Windows Azure Mobile Service returned a login response
// with invalid syntax.
#define MSLoginInvalidResponseSyntax            -1502

// Indicates that the login operation was canceled.
#define MSLoginCanceled                         -1503

// Indicates that the login operation failed because a nil token was used.
#define MSLoginExpectedToken                    -1504

// Indicates that the login operation failed because an invalid token was used.
#define MSLoginInvalidToken                     -1505

#endif
