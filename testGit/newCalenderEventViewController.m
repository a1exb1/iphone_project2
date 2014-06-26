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
//@property (weak, nonatomic) IBOutlet UIDatePicker *lessonDatePicker;
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
    today = [Tools dateRoundedDownTo5Minutes:today];
    
    
    
    if(session.hasSetDefaults && _useDefaults){
        //_lesson.Hour = session.lessonSlotSelectedHour;
        //_lesson.Mins = session.lessonSlotSelectedMin;
        //_lesson.Weekday = session.lessonSlotSelectedWeekday;
        _link.Hour = session.lessonSlotSelectedHour;
        _link.Mins = session.lessonSlotSelectedMin;
        _link.Weekday = session.lessonSlotSelectedWeekday;
        if(session.lessonSlotSelectedCourse != nil){
            _link.course = session.lessonSlotSelectedCourse;
            _lesson.course = session.lessonSlotSelectedCourse;
        }
        
    }
    
    
    if(_isLink){
        _link.tutor = [session tutor];
        if([_link StudentCourseLinkID] > 0)
            self.title = @"Edit slot";
        
        else
            self.title = @"New slot";
    }
    
    else{
        if(_dayDate == nil){
            _dayDate = today;
            _lesson.dateTime = today;
        }
        
        if(_lesson == nil){
            _lesson = [[Lesson alloc] init];
            _lesson.dateTime = _dayDate;
        }
        
        if(!_lesson.LessonID > 0){
            //[_lessonDatePicker setMinimumDate:today];
            _minDate = today;
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate: today];
            
            if(_dayDate != nil){
                
                NSCalendar *gregorian2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *components2 = [gregorian2 components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate: _dayDate];
                components2.hour = components.hour;
                components2.minute = components.minute;
                //[_lessonDatePicker setDate:[gregorian dateFromComponents:components2]]; //??
                _dayDate = [gregorian dateFromComponents:components2];
            }
            
            
        }
        
//        else{
//            //[_lessonDatePicker setDate:_dayDate];
//        }
        
        _studentLbl.text = [[_lesson student] name];
        _courseLbl.text = [[_lesson course] name];
        
        if([_lesson LessonID] > 0)
            self.title = @"Edit lesson";
        
        else
            self.title = @"New lesson";

    }
    
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(authorizeDelete)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    if ([_lesson LessonID] > 0 || _link.StudentCourseLinkID > 0) {
        self.navigationItem.leftBarButtonItem = deleteBtn;
    }
    self.navigationController.navigationBar.translucent = NO;
    

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    
    

}

//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [[UIView alloc] init];
//}

-(void)save
{
    if(_isLink)
    {
        if ([_link student] == nil || [_link course] == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a course, student and day." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        else{
            NSArray *result = _link.saveReturn;
            
            if([[[result objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"1"])
            {
                [self.delegate reload];
            }
            else if([[[result objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"0"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[result objectAtIndex:0] objectForKey:@"errormsg" ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if([[[result objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"3"])
            {
                //[self.editLessonSlotDelegate updatedSlot: _studentCourseLink];
                [self.delegate reload];
                
            }
        }
        
        
        session.lessonSlotSelectedCourse = [_link course];
        session.lessonSlotSelectedHour = [_link Hour];
        session.lessonSlotSelectedMin = [_link Mins];
        session.lessonSlotSelectedWeekday = [_link Weekday];
        session.hasSetDefaults = YES;
    }
    
    else{
        // LESSON
        session.lessonSlotSelectedCourse = [_lesson course];
        session.lessonSlotSelectedHour = [_lesson Hour];
        session.lessonSlotSelectedMin = [_lesson Mins];
        session.lessonSlotSelectedWeekday = [_lesson Weekday];
        session.hasSetDefaults = YES;
        
        if ([_lesson student] == nil || [_lesson course] == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a course, student and lesson time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            [_lesson setDateTime: _dayDate];
            [_lesson setTutor:[session tutor]];
            
            NSArray *result = _lesson.saveReturn;
            if([[[result objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"1"])
            {
                [self.delegate reload];
            }
            
            
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[result objectAtIndex:0] objectForKey:@"errormsg" ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        [self delete];
    }
}

-(void)authorizeDelete{
    //if(_isLink)
        //NSString *msg = [NSString stringWithFormat:@""];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm delete"
                                                    message:@"Are you sure you want to delete?"
                                                   delegate:self    // <------
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete", nil];
    [alert show];
}


-(void)delete
{
    if(_isLink){
        NSArray *result = _link.deleteReturn;
        
        if([[[result objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"3"])
        {
            [self.delegate reload];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[result objectAtIndex:0] objectForKey:@"errormsg" ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else{
        NSArray *result = _lesson.deleteReturn;
        
        if([[[result objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"3"])
        {
            [self.delegate reload];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[result objectAtIndex:0] objectForKey:@"errormsg" ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    if(_isLink){
        if(indexPath.row == 0){
            if ([_link student] == nil)
                cell.textLabel.text = @"Select student";
            
            else{
                cell.textLabel.text = @"Student";
                cell.detailTextLabel.text = [[_link student] name];
            }
            
        }
        else if(indexPath.row == 1){
            if([_link course] == nil)
                cell.textLabel.text = @"Select course";
            
            else{
                cell.textLabel.text = @"Course";
                cell.detailTextLabel.text = [[_link course] name];
            }
        }
        
        else if(indexPath.row == 2){
            cell.textLabel.text = @"Day";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %0.2d:%0.2d", [[Tools daysOfWeekArraySundayFirst] objectAtIndex:[_link Weekday]], [_link Hour], [_link Mins]];
            
        }
        
        else if(indexPath.row == 3){
            if([_link Duration] == 0)
                cell.textLabel.text = @"Select duration";
            
            else{
                cell.textLabel.text = @"Duration";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [_link Duration]];
            }
        }
    }
    
    else // LESSON
    {
        if(indexPath.row == 0){
            if ([_lesson student] == nil)
                cell.textLabel.text = @"Select student";
            
            else{
                cell.textLabel.text = @"Student";
                cell.detailTextLabel.text = [[_lesson student] name];
            }
            
        }
        else if(indexPath.row == 1){
            if([_lesson course] == nil)
                cell.textLabel.text = @"Select course";
            
            else{
                cell.textLabel.text = @"Course";
                cell.detailTextLabel.text = [[_lesson course] name];
            }
        }
        
        else if(indexPath.row == 2){
            if([_lesson dateTime] == nil)
                cell.textLabel.text = @"Select date";
            
            else{
                cell.textLabel.text = @"Date";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [Tools formatDate:_dayDate withFormat:@"dd/MM/yyyy HH:mm"]];
            }
        }
        
        else if(indexPath.row == 3){
            if([_lesson Duration] == 0)
                cell.textLabel.text = @"Select duration";
            
            else{
                cell.textLabel.text = @"Duration";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [_lesson Duration]];
            }
        }
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
    
    else if(indexPath.row == 2){
        if(_isLink)
        {
            lessonSlotPickerViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"lessonSlotPicker"];
            view.delegate = (id)self;
            view.link = _link;
            view.title = @"Day and time";
            [self.navigationController pushViewController:view animated:YES];
        }
        
        else{
            DatePickerViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"datePickerView"];
            view.delegate = (id)self;
            view.date = _dayDate;
            view.minDate = _minDate;
            view.title = @"Date";
            [self.navigationController pushViewController:view animated:YES];
        }
        
    }
    
    else if(indexPath.row == 3){
        PickerViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"pickerView"];
        view.delegate = (id)self;
        if(_isLink)
            view.number = _link.Duration;
        
        else
            view.number = _lesson.Duration;
        
        view.title = @"Duration";
        [self.navigationController pushViewController:view animated:YES];
        
    }
    
}

-(void)sendBackDate:(NSDate *)date{
    _dayDate = date;
    _lesson.dateTime = date;
    [self.tableView reloadData];
}

-(void)sendBackStudent:(Student *)student{
    if(_link)
        _link.student = student;
    
    else
        _lesson.student = student;
    
    [self.tableView reloadData];
}

-(void)sendBackCourse:(Course *)course{
    if(_link)
        _link.course = course;
    
    else
        _lesson.course = course;
    
    [self.tableView reloadData];
}

-(void)sendBackInt:(int)number{
    if(_link)
        _link.Duration = number;
    
    else
        _lesson.Duration = number;
    
    [self.tableView reloadData];
}

-(void)sendBackLessonSlot:(StudentCourseLink*)link
{
    _link = link;
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
