// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Beer.h instead.

#import <CoreData/CoreData.h>


@class Brewery;




@interface BeerID : NSManagedObjectID {}
@end

@interface _Beer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BeerID*)objectID;



@property (nonatomic, retain) NSString *details;

//- (BOOL)validateDetails:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) Brewery* brewery;
//- (BOOL)validateBrewery:(id*)value_ error:(NSError**)error_;




@end

@interface _Beer (CoreDataGeneratedAccessors)

@end

@interface _Beer (CoreDataGeneratedPrimitiveAccessors)

- (NSString **)primitiveDetails;
- (void)setPrimitiveDetails:(NSString **)value;


- (NSString **)primitiveName;
- (void)setPrimitiveName:(NSString **)value;




- (Brewery*)primitiveBrewery;
- (void)setPrimitiveBrewery:(Brewery*)value;


@end
