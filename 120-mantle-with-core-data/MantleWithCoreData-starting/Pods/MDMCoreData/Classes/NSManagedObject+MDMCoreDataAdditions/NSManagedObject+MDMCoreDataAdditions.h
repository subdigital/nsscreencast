//
//  NSManagedObject+MDMCoreDataAdditions.h
//
//  Copyright (c) 2014 Matthew Morey.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <CoreData/CoreData.h>

/**
 `NSManagedObject+MDMCoreDataAdditions` is a category on `NSManagedObject` that 
 provides helper methods for eliminating boiler plate code.
 */
@interface NSManagedObject (MDMCoreDataAdditions)

/**
 Returns the name of the entity.
 
 @return The name of the entity.
 */
+ (NSString *)MDMCoreDataAdditionsEntityName;

/**
 Creates, configures, and returns an instance of the class for the entity.
 
 @param context The managed object context to use.
 
 @return A new, autoreleased, fully configured instance of the class for the entity. 
 The instance has its entity description set and is inserted it into the `context`.
 */
+ (instancetype)MDMCoreDataAdditionsInsertNewObjectIntoContext:(NSManagedObjectContext *)context;

@end
