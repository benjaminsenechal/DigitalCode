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
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *roomsPicker;
@property (strong, nonatomic) NSArray *rooms;
@property (strong, nonatomic) BDAcces *db;
@end

@implementation ViewController

#pragma mark Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _code.text = @"";
    _rooms = @[@"Salle 1",@"Salle 2",@"Salle 3"];
}

#pragma mark Generate unique code

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

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _rooms.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return _rooms[row];
}

@end
