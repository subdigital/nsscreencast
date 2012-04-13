// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Beer.m instead.

#import "_Beer.h"

@implementation BeerID
@end

@implementation _Beer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Beer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Beer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Beer" inManagedObjectContext:moc_];
}

- (BeerID*)objectID {
	return (BeerID*)[super objectID];
}




@dynamic details;






@dynamic name;






@dynamic brewery;

	





@end
