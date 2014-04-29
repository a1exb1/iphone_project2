//
//  editStudentViewController.m
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "editStudentViewController.h"
#import "Student.h"

@interface editStudentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *youSelectedLbl;


@end

@implementation editStudentViewController

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
    self.youSelectedLbl.text = [NSString stringWithFormat:@"%@", [_student name]];
    
    
    if([_student studentID] == 0) {
        self.title = @"New Student";
    }
    else{
        self.title = @"Edit Student";
    }
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

-(IBAction)saveStudent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
//    int newWeekday = (int)[_lessonTimePicker selectedRowInComponent:0] ;
//    int newHour = [[_HoursArray objectAtIndex:[_lessonTimePicker selectedRowInComponent:1 ]] intValue];
//    int newMins = [[_MinutesArray objectAtIndex:[_lessonTimePicker selectedRowInComponent:2 ]] intValue];
//    int newDuration = [[_DurationArray objectAtIndex:[_lessonTimePicker selectedRowInComponent:2 ]] intValue];
    
    Student *newStudent = [[Student alloc] init];
    [newStudent setStudentID:[_student studentID]];
    [newStudent setName:[_student name]];
    
//    StudentCourseLink *newStudentCourseLink = [[StudentCourseLink alloc] init];
//    [newStudentCourseLink setWeekday:newWeekday];
//    [newStudentCourseLink setHour:newHour];
//    [newStudentCourseLink setHour:newMins];
//    [newStudentCourseLink setHour:newDuration];
//    [newStudent setStudentCourseLink:newStudentCourseLink];
    
    //needs to save this
}

@end
