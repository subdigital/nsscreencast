// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Brewery.m instead.

#import "_Brewery.h"

@implementation BreweryID
@end

@implementation _Brewery

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Brewery" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Brewery";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Brewery" inManagedObjectContext:moc_];
}

- (BreweryID*)objectID {
	return (BreweryID*)[super objectID];
}




@dynamic name;






@dynamic beers;

	
- (NSMutableSet*)beersSet {
	[self willAccessValueForKey:@"beers"];
	NSMutableSet *result = [self mutableSetValueForKey:@"beers"];
	[self didAccessValueForKey:@"beers"];
	return result;
}
	





@end
