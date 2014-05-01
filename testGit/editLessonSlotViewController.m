//
//  editLessonSlotViewController.m
//  testGit
//
//  Created by Alex Bechmann on 29/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "editLessonSlotViewController.h"

@interface editLessonSlotViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *lessonTimePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *lessonDurationPicker;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *studentCourseLbl;

@end

@implementation editLessonSlotViewController

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
    
    [self.lessonTimePicker setDataSource:self];
    [self.lessonTimePicker setDelegate:self];
    [self.lessonDurationPicker setDataSource:self];
    [self.lessonDurationPicker setDelegate:self];
    
    _weekdayArray = [[NSArray alloc] initWithObjects:
                     @"Sun",
                     @"Mon",
                     @"Tue",
                     @"Wed",
                     @"Thu",
                     @"Fri",
                     @"Sat",
                     nil];
    
    
    
    _HoursArray = [[NSArray alloc] initWithObjects:
                   @"00",@"01",@"02",@"03",@"04",@"05", @"06",@"07",@"08",@"09",@"10",@"11",@"12" , @"13",@"14",@"15",@"16",@"17",@"18", @"19",@"20",@"21",@"22",@"23",@"24", nil];
    
    
    _MinutesArray = [[NSArray alloc] initWithObjects:
                     @"00",@"5",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55",nil];
    
    
    _DurationArray = [[NSArray alloc] initWithObjects:
                      @"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55",@"60",@"65",@"70",@"75",@"80",@"85",@"90",nil];
    
    
    _ComponentsArray =[[NSArray alloc]
                       initWithObjects: _weekdayArray, _HoursArray, _MinutesArray, _DurationArray, nil];
    
    
    [self.lessonTimePicker selectRow:[[_student studentCourseLink] Weekday] inComponent:0 animated:YES];
    
    [self.lessonTimePicker selectRow:[[_student studentCourseLink] Hour] inComponent:1 animated:YES];
    
    int minsFromArray = [[_student studentCourseLink] Mins] / 5;
    int durationFromArray = [[_student studentCourseLink] Duration] / 5;
    durationFromArray = durationFromArray - 4;
    
    [self.lessonTimePicker selectRow:minsFromArray inComponent:2 animated:YES];
    [self.lessonDurationPicker selectRow:durationFromArray inComponent:0 animated:YES];
    
    
    
    NSLog(@"courseid: %li", [[[_student studentCourseLink] course] courseID]);
    NSLog(@"studentid: %li", [_student studentID]);
//    if([_student studentID] == 0) {
//        self.title = @"New Student";
//    }
//    else{
//        self.title = @"Edit Student";
//    }

}

// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView == self.lessonTimePicker) {
        return 3;
    }
    else {
        return 1;
    }
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == self.lessonTimePicker) {
        return [[_ComponentsArray objectAtIndex:component ] count];
    }
    else{
        return [_DurationArray count];
    }
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == self.lessonTimePicker) {
        return [[_ComponentsArray objectAtIndex:component ] objectAtIndex:row];
    }
    else{
        return [_DurationArray objectAtIndex:row];
    }
    
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //    NSMutableArray *categoryArray = [categoriesArray objectAtIndex:row];
    //    NSString *string = [categoryArray objectAtIndex:0];
    //    _ProductCategoryID.text = string;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
