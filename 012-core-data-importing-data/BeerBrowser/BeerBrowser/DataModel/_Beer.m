// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Beer.m instead.

#import "_Beer.h"

const struct BeerAttributes BeerAttributes = {
	.details = @"details",
	.name = @"name",
};

const struct BeerRelationships BeerRelationships = {
	.brewery = @"brewery",
};

const struct BeerFetchedProperties BeerFetchedProperties = {
};

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

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic details;






@dynamic name;






@dynamic brewery;

	






@end
