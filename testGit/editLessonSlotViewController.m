//
//  editLessonSlotViewController.m
//  testGit
//
//  Created by Alex Bechmann on 29/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "editLessonSlotViewController.h"
#import "Tools.h"
//#import "editStudentAndSlotViewController.h"
#import "Session.h"

@interface editLessonSlotViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *lessonTimePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *lessonDurationPicker;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *studentCourseLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

@implementation editLessonSlotViewController

extern Session *session;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if(![Tools isIpad])
    {
        [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:[Tools colorFromHexString:@"#4473b4"] andTint:[UIColor whiteColor] theme:@"dark"];
    }
    if(![self.accessibilityValue isEqualToString:@"coursePopover"])
    {
        self.preferredContentSize = CGSizeMake(320, 568);
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.calenderViewDelegate = (id)[session calController];
    //self.calenderViewDelegate = (id)self;
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
    
    
    [self.lessonTimePicker selectRow:[_studentCourseLink Weekday] inComponent:0 animated:YES];
    
    [self.lessonTimePicker selectRow:[_studentCourseLink Hour] inComponent:1 animated:YES];
    
    int minsFromArray = [_studentCourseLink Mins] / 5;
    int durationFromArray = [_studentCourseLink Duration] / 5;
    durationFromArray = durationFromArray - 4;
    
    [self.lessonTimePicker selectRow:minsFromArray inComponent:2 animated:YES];
    [self.lessonDurationPicker selectRow:durationFromArray inComponent:0 animated:YES];
    
    self.studentNameLbl.text = [[_studentCourseLink student] name];
    self.studentCourseLbl.text = [[_studentCourseLink course] name];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    
    if ([_studentCourseLink StudentCourseLinkID] > 0) {
        UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(authorizeDelete)];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveBtn, deleteBtn, nil]];
    }
    else{
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveBtn, nil]];
    }
        
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        [self delete];
        
    }
    
}

-(void)authorizeDelete{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm delete"
                                                    message:@"Are you sure you want to delete?"
                                                   delegate:self    // <------
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete lesson", nil];
    [alert show];
}

-(void)delete{
    [Tools showLoader];
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=studentcourselink&id=%li&delete=1&clientid=%li&ts=%f", [_studentCourseLink StudentCourseLinkID], [[session client] clientID], [[NSDate date] timeIntervalSince1970]];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
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

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)save{
    [Tools showLoader];
    
    int newWeekday = (int)[_lessonTimePicker selectedRowInComponent:0] ;
    int newHour = [[_HoursArray objectAtIndex:[_lessonTimePicker selectedRowInComponent:1 ]] intValue];
    int newMins = [[_MinutesArray objectAtIndex:[_lessonTimePicker selectedRowInComponent:2 ]] intValue];
    int newDuration = [[_DurationArray objectAtIndex:[_lessonDurationPicker selectedRowInComponent:0 ]] intValue];
    
    [_studentCourseLink setWeekday:newWeekday];
    [_studentCourseLink setHour:newHour];
    [_studentCourseLink setMins:newMins];
    [_studentCourseLink setDuration:newDuration];
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=studentcourselink&id=%li&hour=%i&mins=%i&studentid=%li&courseid=%li&weekday=%i&duration=%i&tutorid=%li&clientid=%li&ts=%f", [_studentCourseLink StudentCourseLinkID], newHour, newMins,[[_studentCourseLink student] studentID],[[_studentCourseLink course]courseID], newWeekday,newDuration,[[_studentCourseLink course] tutorID], [[session client] clientID], [[NSDate date] timeIntervalSince1970]];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}



-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc]init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    [_data appendData:theData];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [Tools hideLoader];
    _saveResultArray = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"1"])
    {
        [self.editLessonSlotDelegate updatedSlot: _studentCourseLink];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:_popViews] animated:YES];
        [self.calenderViewDelegate reloadWebView];
    }
    else if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"0"]){
        
        NSString *error = [NSString stringWithFormat:@"%@",[[_saveResultArray objectAtIndex:0] objectForKey:@"errormsg" ] ];
        
        self.statusLbl.text = error;
        self.statusLbl.hidden = NO;
    }
    else if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"3"])
    {
        //[self.editLessonSlotDelegate updatedSlot: _studentCourseLink];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
        [self.calenderViewDelegate reloadWebView];

    }
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [Tools hideLoader];
}
//


@end
