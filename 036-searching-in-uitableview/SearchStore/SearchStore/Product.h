#import "_Product.h"

@interface Product : _Product {}

+ (int)productCountWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
