#import "Brewery.h"
#import "NSDictionary+ObjectForKeyOrNil.h"

@implementation Brewery

+ (Brewery *)breweryWithServerId:(NSInteger)serverId usingManagedObjectContext:(NSManagedObjectContext *)moc {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Brewery entityName]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"serverId = %d", serverId]];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"ERROR: %@ %@", [error localizedDescription], [error userInfo]);
        exit(1);
    }
    
    if ([results count] == 0) {
        return nil;
    }
    
    return [results objectAtIndex:0];
}

- (void)updateAttributes:(NSDictionary *)attributes {
    self.name       = [attributes objectForKeyOrNil:@"name"];
    self.address1   = [attributes objectForKeyOrNil:@"address1"];
    self.address2   = [attributes objectForKeyOrNil:@"address2"];
    self.city       = [attributes objectForKeyOrNil:@"city"];
    self.state      = [attributes objectForKeyOrNil:@"state"];
    self.country    = [attributes objectForKeyOrNil:@"country"];
    self.postalCode = [attributes objectForKeyOrNil:@"postalCode"];
    self.details    = [attributes objectForKeyOrNil:@"description"];
    self.website    = [attributes objectForKeyOrNil:@"website"];
}

@end
