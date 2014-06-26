//
//  lessonSlotPickerViewController.m
//  Music Lesson Manager
//
//  Created by Alex Bechmann on 26/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "lessonSlotPickerViewController.h"

@interface lessonSlotPickerViewController ()


@end

@implementation lessonSlotPickerViewController

NSArray *weekdayArray;
NSArray *hoursArray;
NSArray *minutesArray;
NSArray *componentsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weekdayArray = [[NSArray alloc] initWithObjects:
                     @"Sun",
                     @"Mon",
                     @"Tue",
                     @"Wed",
                     @"Thu",
                     @"Fri",
                     @"Sat",
                     nil];
    
    hoursArray = [[NSArray alloc] initWithObjects:
                   @"00",@"01",@"02",@"03",@"04",@"05", @"06",@"07",@"08",@"09",@"10",@"11",@"12" , @"13",@"14",@"15",@"16",@"17",@"18", @"19",@"20",@"21",@"22",@"23",@"24", nil];
    
    
    minutesArray = [[NSArray alloc] initWithObjects:
                     @"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55",nil];

    
    int minsFromArray = [_link Mins] / 5;
    [self.picker selectRow:minsFromArray inComponent:2 animated:YES];
    
    componentsArray =[[NSArray alloc]
                       initWithObjects: weekdayArray, hoursArray, minutesArray, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return [componentsArray count];
    
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [[componentsArray objectAtIndex:component ] count];
    
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [componentsArray objectAtIndex:row];
    
}

-(IBAction)selectTime
{
    int newWeekday = (int)[_picker selectedRowInComponent:0] ;
    int newHour = [[hoursArray objectAtIndex:[_picker selectedRowInComponent:1 ]] intValue];
    int newMins = [[minutesArray objectAtIndex:[_picker selectedRowInComponent:2 ]] intValue];
    [_link setWeekday:newWeekday];
    [_link setHour:newHour];
    [_link setMins:newMins];
    
    [self.delegate sendBackLessonSlot:_link];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
