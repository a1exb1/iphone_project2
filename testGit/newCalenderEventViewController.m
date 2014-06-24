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
    [_lessonDatePicker setMinimumDate:today];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    if ([_lesson LessonID] > 0) {
        self.navigationItem.leftBarButtonItem = deleteBtn;
    }
    self.navigationController.navigationBar.translucent = NO;
    
    if(_lesson == nil){
        _lesson = [[Lesson alloc] init];
    }
    
    _studentLbl.text = [[_lesson student] name];
    _courseLbl.text = [[_lesson course] name];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    

}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(void)save
{
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
        view.loaded = NO;
        
        [self.navigationController pushViewController:view animated:YES];
    }
    
    else if(indexPath.row == 1){
        clientCoursesTableViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"clientCourses"];
        view.accessibilityValue = @"lessonPopover";
        view.delegate = (id)self;
        view.loaded = NO;
        view.popover = YES;
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
