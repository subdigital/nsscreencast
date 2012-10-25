#import "Product.h"

@implementation Product

+ (int)productCountWithManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *countRequest = [[NSFetchRequest alloc] init];
    [countRequest setEntity:[self entityInManagedObjectContext:context]];
    NSError *error = nil;
    int count = [context countForFetchRequest:countRequest error:&error];
    if (error) {
        [NSException raise:NSGenericException format:@"Couldn't fetch the count of product entities: %@", error];
    }

    return count;
}

@end
