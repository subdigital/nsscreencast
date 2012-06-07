#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "UA_FMResultSet.h"

@interface UA_FMDatabase : NSObject 
{
	sqlite3*    db;
	NSString*   databasePath;
    BOOL        logsErrors;
    BOOL        crashOnErrors;
    BOOL        inUse;
    BOOL        inTransaction;
    BOOL        traceExecution;
    BOOL        checkedOut;
    int         busyRetryTimeout;
    BOOL        shouldCacheStatements;
    NSMutableDictionary *cachedStatements;
}


+ (id)databaseWithPath:(NSString*)inPath;
- (id)initWithPath:(NSString*)inPath;

- (BOOL) open;
#if SQLITE_VERSION_NUMBER >= 3005000
- (BOOL) openWithFlags:(int)flags;
#endif
- (void) close;
- (BOOL) goodConnection;
- (void) clearCachedStatements;

// encryption methods.  You need to have purchased the sqlite encryption extensions for these to work.
- (BOOL) setKey:(NSString*)key;
- (BOOL) rekey:(NSString*)key;


- (NSString *) databasePath;

- (NSString*) lastErrorMessage;

- (int) lastErrorCode;
- (BOOL) hadError;
- (sqlite_int64) lastInsertRowId;

- (sqlite3*) sqliteHandle;

- (BOOL) executeUpdate:(NSString*)sql, ...;
- (BOOL) executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;
- (id) executeQuery:(NSString *)sql withArgumentsInArray:(NSArray*)arrayArgs orVAList:(va_list)args; // you shouldn't ever need to call this.  use the previous two instead.

- (id) executeQuery:(NSString*)sql, ...;
- (id) executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments;
- (BOOL) executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray*)arrayArgs orVAList:(va_list)args; // you shouldn't ever need to call this.  use the previous two instead.

- (BOOL) rollback;
- (BOOL) commit;
- (BOOL) beginTransaction;
- (BOOL) beginDeferredTransaction;

- (BOOL)logsErrors;
- (void)setLogsErrors:(BOOL)flag;

- (BOOL)crashOnErrors;
- (void)setCrashOnErrors:(BOOL)flag;

- (BOOL)inUse;
- (void)setInUse:(BOOL)value;

- (BOOL)inTransaction;
- (void)setInTransaction:(BOOL)flag;

- (BOOL)traceExecution;
- (void)setTraceExecution:(BOOL)flag;

- (BOOL)checkedOut;
- (void)setCheckedOut:(BOOL)flag;

- (int)busyRetryTimeout;
- (void)setBusyRetryTimeout:(int)newBusyRetryTimeout;

- (BOOL)shouldCacheStatements;
- (void)setShouldCacheStatements:(BOOL)value;

- (NSMutableDictionary *)cachedStatements;
- (void)setCachedStatements:(NSMutableDictionary *)value;


+ (NSString*) sqliteLibVersion;


- (int)changes;

// The following methods from FMDatabaseAdditions. Removing the category
// to simplify linker flags
//
//  UA_FMDatabaseAdditions.h
//  fmkit
//
//  Created by August Mueller on 10/30/05.
//  Copyright 2005 Flying Meat Inc.. All rights reserved.
//

- (int)intForQuery:(NSString*)objs, ...;
- (long)longForQuery:(NSString*)objs, ...; 
- (BOOL)boolForQuery:(NSString*)objs, ...;
- (double)doubleForQuery:(NSString*)objs, ...;
- (NSString*)stringForQuery:(NSString*)objs, ...; 
- (NSData*)dataForQuery:(NSString*)objs, ...;
- (NSDate*)dateForQuery:(NSString*)objs, ...;

// Notice that there's no dataNoCopyForQuery:.
// That would be a bad idea, because we close out the result set, and then what
// happens to the data that we just didn't copy?  Who knows, not I.


- (BOOL)tableExists:(NSString*)tableName;
- (UA_FMResultSet*)getSchema;
- (UA_FMResultSet*)getTableSchema:(NSString*)tableName;
- (BOOL)columnExists:(NSString*)tableName columnName:(NSString*)columnName;

@end

@interface UA_FMStatement : NSObject {
    sqlite3_stmt *statement;
    NSString *query;
    long useCount;
}


- (void) close;
- (void) reset;

- (sqlite3_stmt *)statement;
- (void)setStatement:(sqlite3_stmt *)value;

- (NSString *)query;
- (void)setQuery:(NSString *)value;

- (long)useCount;
- (void)setUseCount:(long)value;


@end

