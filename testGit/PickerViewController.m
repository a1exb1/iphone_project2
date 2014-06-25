//
//  PickerViewController.m
//  Music Lesson Manager
//
//  Created by Alex Bechmann on 25/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()

@end

@implementation PickerViewController

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
    
    self.picker.delegate = self;
    self.picker.dataSource = self;
    
    _dataArray = [[NSArray alloc] initWithObjects:
                  @"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55",@"60",@"65",@"70",@"75",@"80",@"85",@"90",nil];
    
    int durationFromArray = _number / 5;
    durationFromArray = durationFromArray - 4;
    
    [self.picker selectRow:durationFromArray inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
    
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return [_dataArray count];
    
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    return [_dataArray objectAtIndex:row];

}

// Do something with the selected row.

-(IBAction)selectNumber
{
    int durationFromPicker = [[_dataArray objectAtIndex:[_picker selectedRowInComponent:0 ]] intValue];
    
    [self.delegate sendBackInt:durationFromPicker];
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
