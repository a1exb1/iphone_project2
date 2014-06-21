//
//  clientCoursesTableViewController.m
//  PlanIt!
//
//  Created by Alex Bechmann on 20/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "clientCoursesTableViewController.h"

@interface clientCoursesTableViewController ()

@end

@implementation clientCoursesTableViewController

extern Session *session;

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
        [[session client] setCourses:[[NSArray alloc] init]];
        [self.tableView reloadData];
        [Tools showLightLoaderWithView:self.view];
        [[session client] loadCoursesAsyncWithDelegate:self];
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
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    NSDictionary *tutor = [[[session client] courses] objectAtIndex:indexPath.section];
    NSArray *courses = [tutor objectForKey:@"courses"];
    NSArray *course = [courses objectAtIndex:indexPath.row];
    
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
    return [[[session client] courses]count];
    //return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *tutor = [[[session client] courses] objectAtIndex:section];
    NSArray *courses = [tutor objectForKey:@"courses"];
    //return [[tutor objectForKey:@"courses"] count];
    return [courses count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *tutor = [[[session client] courses] objectAtIndex:section];
    NSString *status = @"";
    NSArray *courses = [tutor objectForKey:@"courses"];
    if ([courses count] == 0) {
        status = @"(No courses)";
    }
    return [NSString stringWithFormat:@"%@ %@", [tutor objectForKey:@"tutorname"], status];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //onclick for each object, put to label for example
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //self.tutorIDSender = cell.accessibilityValue;
    //self.tutorNameSender = cell.textLabel.text;
    //[self performSegueWithIdentifier:@"TutorsToCourses" sender:self];
    NSDictionary *tutorDict = [[[session client] courses] objectAtIndex:indexPath.section];
    NSArray *courses = [tutorDict objectForKey:@"courses"];
    NSArray *courseArr = [courses objectAtIndex:indexPath.row];
    
    Course *course = [[Course alloc] init];
    [course setCourseID:[[courseArr objectAtIndex:0] intValue]];
    [course setName:cell.textLabel.text];
    
    saveCourseViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"saveCourseL"];
    view.course = course;
    
    NSArray *tutorid = [tutorDict objectForKey:@"tutorid"];
    NSString *str = [[NSString alloc] initWithFormat:@"%@", tutorid];
    Tutor *tutor = [[Tutor alloc] init];
    [tutor setName:[tutorDict objectForKey:@"tutorname"]];
    [tutor setTutorID:[str intValue]];
    view.tutor = tutor;
    [self.navigationController pushViewController:view animated:YES];
}

- (void) finished:(NSString *)status withArray:(NSArray *)array;
{
    [[session client] setCourses:array];
    [self.tableView reloadData];
    [Tools hideLoaderFromView:self.view];
}

@end
