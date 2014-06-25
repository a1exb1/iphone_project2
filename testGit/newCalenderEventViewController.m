//
//  newCalenderEventViewController.m
//  PlanIt!
//
//  Created by Alex Bechmann on 23/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "newCalenderEventViewController.h"

@interface newCalenderEventViewController ()
@property (weak, nonatomic) IBOutlet UILabel *studentLbl;
@property (weak, nonatomic) IBOutlet UILabel *courseLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *lessonDatePicker;
@end

@implementation newCalenderEventViewController

extern Session *session;

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
    NSDate *today = [[NSDate alloc] init];
    
    if(_lesson == nil){
        _lesson = [[Lesson alloc] init];
    }
    
    if(!_lesson.LessonID > 0){
        [_lessonDatePicker setMinimumDate:today];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate: today];
        
        if(_dayDate != nil){
            
            NSCalendar *gregorian2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components2 = [gregorian2 components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate: _dayDate];
            components2.hour = components.hour;
            components2.minute = components.minute;
            [_lessonDatePicker setDate:[gregorian dateFromComponents:components2]]; //??
        }
   
    
    }
    
    else{
        [_lessonDatePicker setDate:_dayDate];
    }
        
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    if ([_lesson LessonID] > 0) {
        self.navigationItem.leftBarButtonItem = deleteBtn;
    }
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    _studentLbl.text = [[_lesson student] name];
    _courseLbl.text = [[_lesson course] name];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    
    if([_lesson LessonID] > 0)
        self.title = @"Edit lesson";

}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(void)save
{
    if ([_lesson student] == nil || [_lesson course] == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a course, student and lesson time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        [_lesson setDateTime: self.lessonDatePicker.date];
        [_lesson setTutor:[session tutor]];
        
        if([[[_lesson.saveReturn objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"1"])
        {
            [self.delegate reload];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[_lesson.saveReturn objectAtIndex:0] objectForKey:@"errormsg" ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void)delete
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    if(indexPath.row == 0){
        if ([_lesson student] == nil)
            cell.textLabel.text = @"Select student";

        else
            cell.textLabel.text = [[_lesson student] name];

    }
    else if(indexPath.row == 1){
        if([_lesson course] == nil)
            cell.textLabel.text = @"Select course";
        
        else
            cell.textLabel.text = [[_lesson course] name];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        allStudentsTableViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"allStudents"];
        view.accessibilityValue = @"lessonPopover";
        view.delegate = (id)self;
        view.loaded = YES;
        view.popover = YES;
        view.tableView.backgroundColor = [UIColor clearColor];
        [self.navigationController pushViewController:view animated:YES];
    }
    
    else if(indexPath.row == 1){
        clientCoursesTableViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"clientCourses"];
        view.accessibilityValue = @"lessonPopover";
        view.delegate = (id)self;
        view.loaded = YES;
        view.popover = YES;
        view.tableView.backgroundColor = [UIColor clearColor];
        [self.navigationController pushViewController:view animated:YES];
        
    }
    
}

-(void)sendBackStudent:(Student *)student{
    _lesson.student = student;
    [self.tableView reloadData];
}

-(void)sendBackCourse:(Course *)course{
    _lesson.course = course;
    [self.tableView reloadData];
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
