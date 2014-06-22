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
    self.title = [NSString stringWithFormat:@"Courses (%@)", [[session client] name]];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if(!_loaded){
        [[session client] setStudents:[[NSArray alloc] init]];
        [self.tableView reloadData];
        [Tools showLightLoaderWithView:self.view];
        [[session client] loadStudentsAsyncWithDelegate:self];
        [self.navigationItem setHidesBackButton:YES];
        _loaded = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if(_loaded){
        [[session client] setCourses:[[NSArray alloc] init]];
        [self.tableView reloadData];
        [Tools showLightLoaderWithView:self.view];
        [[session client] loadCoursesAsyncWithDelegate:self];
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

    return [[[session client] students] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *tutor = [[[session client] courses] objectAtIndex:section];
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
    
    NSDictionary *tutorDict = [[[session client] courses] objectAtIndex:indexPath.section];
    NSArray *students = [tutorDict objectForKey:@"students"];
    NSArray *studentsArr = [students objectAtIndex:indexPath.row];
    
    Student *student = [[Student alloc] init];
    [student setStudentID:[[studentsArr objectAtIndex:0] intValue]];
    [student setName:cell.textLabel.text];
    
    editStudentViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"saveStudent"];
    view.studentID = [NSString stringWithFormat:@"%ld", student.studentID];
    [self.navigationController pushViewController:view animated:YES];
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
    [[session client] setCourses:array];
    [self.tableView reloadData];
    [Tools hideLoaderFromView:self.view];
}

@end
