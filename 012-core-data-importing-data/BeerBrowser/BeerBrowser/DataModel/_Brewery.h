// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Brewery.h instead.

#import <CoreData/CoreData.h>


extern const struct BreweryAttributes {
	__unsafe_unretained NSString *address1;
	__unsafe_unretained NSString *address2;
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *country;
	__unsafe_unretained NSString *details;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *postalCode;
	__unsafe_unretained NSString *serverId;
	__unsafe_unretained NSString *state;
	__unsafe_unretained NSString *website;
} BreweryAttributes;

extern const struct BreweryRelationships {
	__unsafe_unretained NSString *beers;
} BreweryRelationships;

extern const struct BreweryFetchedProperties {
} BreweryFetchedProperties;

@class Beer;












@interface BreweryID : NSManagedObjectID {}
@end

@interface _Brewery : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BreweryID*)objectID;




@property (nonatomic, strong) NSString* address1;


//- (BOOL)validateAddress1:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* address2;


//- (BOOL)validateAddress2:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* city;


//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* country;


//- (BOOL)validateCountry:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* details;


//- (BOOL)validateDetails:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* postalCode;


//- (BOOL)validatePostalCode:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* serverId;


@property int16_t serverIdValue;
- (int16_t)serverIdValue;
- (void)setServerIdValue:(int16_t)value_;

//- (BOOL)validateServerId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* state;


//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* website;


//- (BOOL)validateWebsite:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* beers;

- (NSMutableSet*)beersSet;





@end

@interface _Brewery (CoreDataGeneratedAccessors)

- (void)addBeers:(NSSet*)value_;
- (void)removeBeers:(NSSet*)value_;
- (void)addBeersObject:(Beer*)value_;
- (void)removeBeersObject:(Beer*)value_;

@end

@interface _Brewery (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAddress1;
- (void)setPrimitiveAddress1:(NSString*)value;




- (NSString*)primitiveAddress2;
- (void)setPrimitiveAddress2:(NSString*)value;




- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;




- (NSString*)primitiveCountry;
- (void)setPrimitiveCountry:(NSString*)value;




- (NSString*)primitiveDetails;
- (void)setPrimitiveDetails:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitivePostalCode;
- (void)setPrimitivePostalCode:(NSString*)value;




- (NSNumber*)primitiveServerId;
- (void)setPrimitiveServerId:(NSNumber*)value;

- (int16_t)primitiveServerIdValue;
- (void)setPrimitiveServerIdValue:(int16_t)value_;




- (NSString*)primitiveState;
- (void)setPrimitiveState:(NSString*)value;




- (NSString*)primitiveWebsite;
- (void)setPrimitiveWebsite:(NSString*)value;





- (NSMutableSet*)primitiveBeers;
- (void)setPrimitiveBeers:(NSMutableSet*)value;


@end
