// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Brewery.m instead.

#import "_Brewery.h"

const struct BreweryAttributes BreweryAttributes = {
	.address1 = @"address1",
	.address2 = @"address2",
	.city = @"city",
	.country = @"country",
	.details = @"details",
	.name = @"name",
	.postalCode = @"postalCode",
	.serverId = @"serverId",
	.state = @"state",
	.website = @"website",
};

const struct BreweryRelationships BreweryRelationships = {
	.beers = @"beers",
};

const struct BreweryFetchedProperties BreweryFetchedProperties = {
};

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

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"serverIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"serverId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic address1;






@dynamic address2;






@dynamic city;






@dynamic country;






@dynamic details;






@dynamic name;






@dynamic postalCode;






@dynamic serverId;



- (int16_t)serverIdValue {
	NSNumber *result = [self serverId];
	return [result shortValue];
}

- (void)setServerIdValue:(int16_t)value_ {
	[self setServerId:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveServerIdValue {
	NSNumber *result = [self primitiveServerId];
	return [result shortValue];
}

- (void)setPrimitiveServerIdValue:(int16_t)value_ {
	[self setPrimitiveServerId:[NSNumber numberWithShort:value_]];
}





@dynamic state;






@dynamic website;






@dynamic beers;

	
- (NSMutableSet*)beersSet {
	[self willAccessValueForKey:@"beers"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"beers"];
  
	[self didAccessValueForKey:@"beers"];
	return result;
}
	






@end
