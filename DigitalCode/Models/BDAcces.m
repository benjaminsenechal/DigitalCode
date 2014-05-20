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
                
                NSString *sql_stmt = @"CREATE TABLE IF NOT EXISTS room (";
                sql_stmt = [sql_stmt stringByAppendingString:@"id VARCHAR PRIMARY KEY);"];
                sql_stmt = [sql_stmt stringByAppendingString:@"CREATE TABLE IF NOT EXISTS code ("];
                sql_stmt = [sql_stmt stringByAppendingString:@"id INTEGER PRIMARY KEY AUTOINCREMENT, "];
                sql_stmt = [sql_stmt stringByAppendingString:@"date DATETIME, "];
                sql_stmt = [sql_stmt stringByAppendingString:@"value INTEGER, "];
                sql_stmt = [sql_stmt stringByAppendingString:@"idRoom VARCHAR, "];
                sql_stmt = [sql_stmt stringByAppendingString:@"FOREIGN KEY(idRoom) REFERENCES room(id));"];
                
                if (sqlite3_exec(_database, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to create table");
                }
                else
                {
                    NSLog(@"Table created");
                    [self insertCode:0000 WithDate:[NSDate date] AndRoom:@"Gruber"];
                    [self insertRoom:@"Gruber"];
                    [self insertRoom:@"Marjorelle"];
                    [self insertRoom:@"Lamour"];
                    
                    [self insertRoom:@"Longwy"];
                    [self insertRoom:@"Galle"];
                    [self insertRoom:@"Corbin"];
                    [self insertRoom:@"Baccarat"];
                    [self insertRoom:@"Multimedia"];
                    [self insertRoom:@"Amphitheatre"];
                    [self insertRoom:@"Convivialite"];
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
        NSString *querySQL = [NSString stringWithFormat:@"SELECT value, date, idRoom FROM code"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int value = sqlite3_column_int(statement, 0);
                char *date = (char*)sqlite3_column_text(statement, 1);
                NSString *dateStr = [[NSString alloc] initWithUTF8String:date];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MM/dd/yyyy h:mm a"];
                NSDate *dateParsed = [dateFormat dateFromString:dateStr];

                char *idRoomChar = (char*)sqlite3_column_text(statement, 2);
                NSString *idRoom = [[NSString alloc] initWithUTF8String:idRoomChar];
                
                Code *code = [[Code alloc]init];
                code.Value = value;
                code.Room = idRoom;
                code.Date = dateParsed;
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

- (NSArray *)rooms{
    NSMutableArray *rooms = [[NSMutableArray alloc] init] ;
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id FROM room"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                char *idRoomChar = (char*)sqlite3_column_text(statement, 0);
                NSString *idRoom = [[NSString alloc] initWithUTF8String:idRoomChar];
                
                Room *room = [[Room alloc]init];
                room.idRoom = idRoom;
                [rooms addObject:room];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_database);
    }else{
        NSLog(@"Error");
    }
    return rooms;
}

- (BOOL)insertCode:(int)value WithDate:(NSDate*)date AndRoom:(NSString *)room{
    BOOL success = false;
    
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO code (value, date, idRoom) VALUES (%d,\"%@\",\"%@\")",value, date, room];
        NSLog(@"%@", insertSQL);
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

- (BOOL)insertRoom:(NSString *)value{
    BOOL success = false;
    
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO room (id) VALUES (\"%@\")",value];
        
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
