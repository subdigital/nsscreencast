/*
 Copyright (C) 2009 Stig Brautaset. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
   to endorse or promote products derived from this software without specific
   prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

extern NSString * UA_SBJSONErrorDomain;


enum {
    UA_EUNSUPPORTED = 1,
    UA_EPARSENUM,
    UA_EPARSE,
    UA_EFRAGMENT,
    UA_ECTRL,
    UA_EUNICODE,
    UA_EDEPTH,
    UA_EESCAPE,
    UA_ETRAILCOMMA,
    UA_ETRAILGARBAGE,
    UA_EEOF,
    UA_EINPUT
};

/**
 @brief common base class for parsing & writing

 This class contains the common error-handling code.
 */
@interface UA_SBJsonBase : NSObject {
    NSMutableArray *errorTrace;
}

/**
 @brief Return an error trace, or nil if there was no errors.
 
 Note that this method returns the trace of the last method that failed.
 You need to check the return value of the call you're making to figure out
 if the call actually failed, before you know call this method.
 */
 @property(copy,readonly) NSArray* errorTrace;

/// @internal for use in subclasses to add errors to the stack trace
- (void)addErrorWithCode:(NSUInteger)code description:(NSString*)str;

/// @internal for use in subclasess to clear the error before a new parsing attempt
- (void)clearErrorTrace;

@end
