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
    self.db = [[BDAcces alloc]init];
    self.code.text = @"";
    self.rooms = [self.db rooms];
}

#pragma mark Generate unique code

- (IBAction)generateCode:(UIButton *)sender {
    self.code.text = [self searchValue];
}

- (NSString *)searchValue{
    NSArray *codesRetrieved = [self.db codes];
    
    int value = [self codeGenerator];
    NSLog(@"%d",value);
    [codesRetrieved enumerateObjectsUsingBlock:^(Code *obj, NSUInteger idx, BOOL *stop) {
        if (obj.Value == value)
        {
            NSLog(@"Value exists");
            *stop = YES;
            [self searchValue];
        }else{
            if([codesRetrieved count]-1 == idx){
                NSLog(@"Good value");
                [self.db insertCode:value WithDate:_datePicker.date AndRoom:@"Gruber"];
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
    return self.rooms.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    Room *r = [self.rooms objectAtIndex:row];
    return [[NSString alloc] initWithFormat:@"%@", r.idRoom];
}

@end
