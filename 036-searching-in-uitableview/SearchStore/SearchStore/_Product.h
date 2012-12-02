// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Product.h instead.

#import <CoreData/CoreData.h>


extern const struct ProductAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *price;
} ProductAttributes;

extern const struct ProductRelationships {
	__unsafe_unretained NSString *category;
} ProductRelationships;

extern const struct ProductFetchedProperties {
} ProductFetchedProperties;

@class Category;




@interface ProductID : NSManagedObjectID {}
@end

@interface _Product : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ProductID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* price;



//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Category *category;

//- (BOOL)validateCategory:(id*)value_ error:(NSError**)error_;





@end

@interface _Product (CoreDataGeneratedAccessors)

@end

@interface _Product (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSDecimalNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSDecimalNumber*)value;





- (Category*)primitiveCategory;
- (void)setPrimitiveCategory:(Category*)value;


@end
