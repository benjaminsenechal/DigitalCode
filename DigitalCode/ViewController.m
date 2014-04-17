//
//  ViewController.m
//  DigitalCode
//
//  Created by Benjamin SENECHAL on 16/04/2014.
//  Copyright (c) 2014 Benjamin SENECHAL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *code;
@property (strong, nonatomic) BDAcces *db;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _code.text = @"";
}

- (IBAction)generateCode:(UIButton *)sender {
    _db = [[BDAcces alloc]init];
    _code.text = [self searchValue];
}

- (NSString*)searchValue{
    NSArray *codesRetrieved = [_db codes];
    
    int value = [self codeGenerator];
    NSLog(@"%d",value);
    [codesRetrieved enumerateObjectsUsingBlock:^(Code *obj, NSUInteger idx, BOOL *stop) {
        if (obj.Value == value)
        {
            //TO DO 
            NSLog(@"Value exists");
            *stop = YES;
            [self searchValue];
        }else{
            if([codesRetrieved count]-1 == idx){
                NSLog(@"Good value");
                [_db insertCode:value];
            }
        }
    }];
    NSString *valueSearched = [[NSString alloc]initWithFormat:@"%d", value];
    return valueSearched;
}

- (int)codeGenerator
{
    return [[NSString stringWithFormat:@"%d%d%d%d", arc4random()%10, arc4random()%10, arc4random()%10, arc4random()%10] intValue];
}

@end
