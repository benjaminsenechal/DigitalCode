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
    BDAcces *bd = [[BDAcces alloc]init];
    [bd insertCode:7890];
    
    NSArray *codesRetrieved = [bd codes];
    NSLog(@"%@",codesRetrieved);
    for (Code *code in codesRetrieved) {
        NSLog(@"%d", code.Value);
    }
}

@end
