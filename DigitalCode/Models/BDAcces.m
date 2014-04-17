//
//  BDAcces.m
//  DigitalCode
//
//  Created by Benjamin SENECHAL on 16/04/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "BDAcces.h"

@implementation BDAcces

static BDAcces *_database;

- (id)init {
    if ((self = [super init])) {
        NSString *docsDir;
        NSArray *dirPaths;
        
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        
        _databasePath = [[NSString alloc] initWithString:
                         [docsDir stringByAppendingPathComponent:@"Codes.sqlite"]];
        
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        if ([filemgr fileExistsAtPath: _databasePath ] == NO)
        {
            const char *dbpath = [_databasePath UTF8String];
            if (sqlite3_open(dbpath, &_database) == SQLITE_OK)
            {
                char *errMsg;
                NSString *sql_stmt = @"CREATE TABLE IF NOT EXISTS codes (";
                sql_stmt = [sql_stmt stringByAppendingString:@"id INTEGER PRIMARY KEY AUTOINCREMENT, "];
                sql_stmt = [sql_stmt stringByAppendingString:@"value INTEGER)"];
                
                if (sqlite3_exec(_database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to create table");
                }
                else
                {
                    NSLog(@"Table created");
                    [self insertCode:0000];
                }
                
                sqlite3_close(_database);
                
            } else {
                NSLog(@"Failed to open/create database");
            }
        }
    }
    return self;
}

- (NSArray *)codes{
    NSMutableArray *codes = [[NSMutableArray alloc] init] ;
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT value FROM codes"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int value = sqlite3_column_int(statement, 0);
                Code *code = [[Code alloc]init];
                code.Value = value;
                [codes addObject:code];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_database);
    }else{
        NSLog(@"Error");
    }
    return codes;
}

- (BOOL)insertCode:(int)value{
    BOOL success = false;
    
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Codes (value) VALUES (%d)",value];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_database, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
        }
        sqlite3_finalize(statement);
        sqlite3_close(_database);
    }else{
        NSLog(@"Error");
    }
    return success;
}

@end
