// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Brewery.h instead.

#import <CoreData/CoreData.h>


@class Beer;



@interface BreweryID : NSManagedObjectID {}
@end

@interface _Brewery : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BreweryID*)objectID;



@property (nonatomic, retain) NSString * name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* beers;
- (NSMutableSet*)beersSet;




@end

@interface _Brewery (CoreDataGeneratedAccessors)

- (void)addBeers:(NSSet*)value_;
- (void)removeBeers:(NSSet*)value_;
- (void)addBeersObject:(Beer*)value_;
- (void)removeBeersObject:(Beer*)value_;

@end

@interface _Brewery (CoreDataGeneratedPrimitiveAccessors)

- (NSString **)primitiveName;
- (void)setPrimitiveName:(NSString **)value;




- (NSMutableSet*)primitiveBeers;
- (void)setPrimitiveBeers:(NSMutableSet*)value;


@end
