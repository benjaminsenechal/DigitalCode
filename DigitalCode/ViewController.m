//
//  ViewController.m
//  DigitalCode
//
//  Created by Benjamin SENECHAL on 16/04/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *codesRetrieved = [BDAcces database].codes;
    NSLog(@"%@",codesRetrieved);
    for (Code *code in codesRetrieved) {
        NSLog(@"%d", code.Value);
    }
    BOOL booo = [[BDAcces database] insertCode:1111];
    NSLog(@"%d", booo);
}


@end
