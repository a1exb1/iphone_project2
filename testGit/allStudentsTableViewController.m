//
//  allStudentsTableViewController.m
//  PlanIt!
//
//  Created by Alex Bechmann on 22/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "allStudentsTableViewController.h"

@interface allStudentsTableViewController ()

@end

extern Session *session;

@implementation allStudentsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"Students (%@)", [[session client] name]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addStudent)];
    
    if([self.accessibilityValue isEqualToString:@"lessonPopover"]){
        self.preferredContentSize = CGSizeMake(320, 568);
    }
    else{
        [self.navigationItem setHidesBackButton:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if(!_loaded){
        [[session client] setStudents:[[NSArray alloc] init]];
        [self.tableView reloadData];
        [Tools showLightLoaderWithView:self.view];
        [[session client] loadStudentsAsyncWithDelegate:self];
        
        _loaded = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if(_loaded){
        [[session client] setStudents:[[NSArray alloc] init]];
        [self.tableView reloadData];
        [Tools showLightLoaderWithView:self.view];
        [[session client] loadStudentsAsyncWithDelegate:self];
        [self.navigationItem setHidesBackButton:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    customTableViewCell *cell = [[customTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    

    NSDictionary *tutor = [[[session client] students] objectAtIndex:indexPath.section];
    NSArray *courses = [tutor objectForKey:@"students"];
    NSArray *course = [courses objectAtIndex:indexPath.row];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.textLabel.text = [course objectAtIndex:1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[[session client] students]count];
    //return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *tutor = [[[session client] students] objectAtIndex:section];
    NSArray *students = [tutor objectForKey:@"students"];
    //return [[tutor objectForKey:@"courses"] count];
    return [students count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *tutor = [[[session client] students] objectAtIndex:section];
    NSString *status = @"";
    NSArray *students = [tutor objectForKey:@"students"];
    if ([students count] == 0) {
        status = @"(No students)";
    }
    return [NSString stringWithFormat:@"%@ %@", [tutor objectForKey:@"tutorname"], status];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //onclick for each object, put to label for example
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *tutorDict = [[[session client] students] objectAtIndex:indexPath.section];
    NSArray *students = [tutorDict objectForKey:@"students"];
    NSArray *tutorIDArr = [tutorDict objectForKey:@"tutorid"];
    long tutorID = [[NSString stringWithFormat:@"%@", tutorIDArr]intValue];
    NSArray *studentsArr = [students objectAtIndex:indexPath.row];
    
    Student *student = [[Student alloc] init];
    [student setStudentID:[[studentsArr objectAtIndex:0] intValue]];
    [student setName:cell.textLabel.text];
    
    editStudentViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"saveStudent"];    
    StudentCourseLink *link = [[StudentCourseLink alloc] init];
    link.student = student;
    
    Tutor *tutor = [[Tutor alloc] init];
    tutor.tutorID = tutorID;
    link.tutor = tutor;
    
    view.studentCourseLink = link;
    view.accessibilityValue = @"allStudents";
    
    if([self.accessibilityValue isEqualToString:@"lessonPopover"]){
        [self.delegate sendBackStudent:student];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController pushViewController:view animated:YES];
    }
    
    _scrollPosition = tableView.contentOffset.y;
    _indexPath = indexPath;
    _pushed = YES;
}

//MARGINED TABLE VIEW
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [Tools marginedtableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(40, 0, self.view.frame.size.width -80, 50)];
    UITableViewHeaderFooterView *sectionView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, container.frame.size.width, 50)];
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(65, 12, sectionView.frame.size.width, 50)];
    sectionHeader.text = [[self tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section] uppercaseString];
    [sectionHeader setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:13]];
    [sectionHeader setTextColor:[UIColor grayColor]];
    [sectionView addSubview:sectionHeader];
    [container addSubview:sectionView];
    
    return container;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void) finished:(NSString *)status withArray:(NSArray *)array;
{
    [[session client] setStudents:array];
    [self.tableView reloadData];
    if(_pushed){
        [self.tableView selectRowAtIndexPath:_indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        if (_scrollPosition < 0) {
            _scrollPosition = 0;
        }
        [self.tableView setContentOffset:CGPointMake(0, _scrollPosition)];
        [self.tableView deselectRowAtIndexPath:_indexPath animated:YES];
    }
    [Tools hideLoaderFromView:self.view];
}

-(void)addStudent
{
    Student *student = [[Student alloc] init];    
    editStudentViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"saveStudent"];
    StudentCourseLink *link = [[StudentCourseLink alloc] init];
    link.student = student;
    view.studentCourseLink = link;
    view.accessibilityValue = @"allStudents";
    [self.navigationController pushViewController:view animated:YES];
    _scrollPosition = self.tableView.contentOffset.y;
    _indexPath = nil;
    _pushed = YES;
}

@end
