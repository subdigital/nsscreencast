#import <Foundation/Foundation.h>
#import "sqlite3.h"

@class UA_FMDatabase;
@class UA_FMStatement;

@interface UA_FMResultSet : NSObject {
    UA_FMDatabase *parentDB;
    UA_FMStatement *statement;
    
    NSString *query;
    NSMutableDictionary *columnNameToIndexMap;
    BOOL columnNamesSetup;
}


+ (id) resultSetWithStatement:(UA_FMStatement *)statement usingParentDatabase:(UA_FMDatabase*)aDB;

- (void) close;

- (NSString *)query;
- (void)setQuery:(NSString *)value;

- (UA_FMStatement *)statement;
- (void)setStatement:(UA_FMStatement *)value;

- (void)setParentDB:(UA_FMDatabase *)newDb;

- (BOOL) next;
- (BOOL) hasAnotherRow;

- (int) columnIndexForName:(NSString*)columnName;
- (NSString*) columnNameForIndex:(int)columnIdx;

- (int) intForColumn:(NSString*)columnName;
- (int) intForColumnIndex:(int)columnIdx;

- (long) longForColumn:(NSString*)columnName;
- (long) longForColumnIndex:(int)columnIdx;

- (long long int) longLongIntForColumn:(NSString*)columnName;
- (long long int) longLongIntForColumnIndex:(int)columnIdx;

- (BOOL) boolForColumn:(NSString*)columnName;
- (BOOL) boolForColumnIndex:(int)columnIdx;

- (double) doubleForColumn:(NSString*)columnName;
- (double) doubleForColumnIndex:(int)columnIdx;

- (NSString*) stringForColumn:(NSString*)columnName;
- (NSString*) stringForColumnIndex:(int)columnIdx;

- (NSDate*) dateForColumn:(NSString*)columnName;
- (NSDate*) dateForColumnIndex:(int)columnIdx;

- (NSData*) dataForColumn:(NSString*)columnName;
- (NSData*) dataForColumnIndex:(int)columnIdx;

- (const unsigned char *) UTF8StringForColumnIndex:(int)columnIdx;
- (const unsigned char *) UTF8StringForColumnName:(NSString*)columnName;

/*
If you are going to use this data after you iterate over the next row, or after you close the
result set, make sure to make a copy of the data first (or just use dataForColumn:/dataForColumnIndex:)
If you don't, you're going to be in a world of hurt when you try and use the data.
*/
- (NSData*) dataNoCopyForColumn:(NSString*)columnName;
- (NSData*) dataNoCopyForColumnIndex:(int)columnIdx;

- (BOOL) columnIndexIsNull:(int)columnIdx;
- (BOOL) columnIsNull:(NSString*)columnName;

- (void) kvcMagic:(id)object;

@end
