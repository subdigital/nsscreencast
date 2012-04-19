#import "_Brewery.h"

@interface Brewery : _Brewery {}

+ (Brewery *)breweryWithServerId:(NSInteger)serverId usingManagedObjectContext:(NSManagedObjectContext *)moc;

- (void)updateAttributes:(NSDictionary *)attributes;

@end
