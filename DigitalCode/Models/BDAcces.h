//
//  BDAcces.h
//  DigitalCode
//
//  Created by Benjamin SENECHAL on 16/04/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Code.h"
#import "Room.h"

@interface BDAcces : NSObject {
    sqlite3 *_database;
}

- (NSArray *)codes;
- (NSArray *)rooms;
- (BOOL)insertCode:(int)value WithDate:(NSDate *)date AndRoom:(int)room;
@property (nonatomic, strong) NSString *databasePath;

@end
