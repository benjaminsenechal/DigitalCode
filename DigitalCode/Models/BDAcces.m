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

+ (BDAcces*)database {
    if (_database == nil) {
        _database = [[BDAcces alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"Codes"
                                                             ofType:@"sqlite"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

- (NSArray *)codes {
    NSMutableArray *retval = [[NSMutableArray alloc] init] ;
    NSString *query = @"SELECT value FROM codes";
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int value = sqlite3_column_int(statement, 0);
            Code *code = [[Code alloc]init];
            code.Value = value;
            [retval addObject:code];
        }
        sqlite3_finalize(statement);
    }
    return retval;
}

-(BOOL)insertCode:(int)value{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO codes (value) VALUES (%d)", value];
    const char *insert_stmt = [insertSQL UTF8String];
    
    sqlite3_prepare_v2(_database, insert_stmt,-1, &statement, NULL);
    
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        return YES;
        NSLog(@"done");
    }else{
        return NO;
        NSLog(@"fail");
    }
    
    sqlite3_reset(statement);
    return NO;
}

@end
