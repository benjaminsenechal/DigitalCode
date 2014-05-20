//
//  Code.h
//  DigitalCode
//
//  Created by Benjamin SENECHAL on 16/04/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Code : NSObject

@property (nonatomic,assign) int Value;
@property (nonatomic, strong) NSDate *Date;
@property (nonatomic,assign) NSString *Room;

@end
