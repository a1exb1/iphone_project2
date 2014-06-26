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
    if(_popover)
         self.title = [NSString stringWithFormat:@"Courses (%@)", [[session tutor] name]];
    else
        self.title = [NSString stringWithFormat:@"Courses (%@)", [[session client] name]];
    
    if([self.accessibilityValue isEqualToString:@"lessonPopover"]){
        self.preferredContentSize = CGSizeMake(320, 310);
    }
    else{
        [self.navigationItem setHidesBackButton:YES];
    }
    [[session client] setCourses:[[NSArray alloc] init]];
    [[session tutor] setCourses:[[NSArray alloc] init]];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(!_loaded){
        [[session client] setCourses:[[NSArray alloc] init]];
        [self.tableView reloadData];
        [Tools showLightLoaderWithView:self.view];
        if (_popover) {
            [[session tutor] loadCoursesAsyncWithDelegate:self];
        }
        else{
            [[session client] loadCoursesAsyncWithDelegate:self];
        }
        
        _loaded = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if(_loaded){
        [[session client] setCourses:[[NSArray alloc] init]];
        [self.tableView reloadData];
        [Tools showLightLoaderWithView:self.view];
        if (_popover) {
            [[session tutor] loadCoursesAsyncWithDelegate:self];
        }
        else{
            [[session client] loadCoursesAsyncWithDelegate:self];
        }
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    _scrollPosition = self.tableView.contentOffset.y;
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, _scrollPosition)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_popover) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        NSLog(@"%@", [[session tutor]courses]);
        cell.textLabel.text = [[[[session tutor] courses]objectAtIndex:indexPath.row]objectForKey:@"CourseName"];
        return cell;
    }
    else{
        
        customTableViewCell *cell = [[customTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        NSDictionary *tutor = [[[session client] courses] objectAtIndex:indexPath.section];
        NSArray *courses = [tutor objectForKey:@"courses"];
        NSArray *course = [courses objectAtIndex:indexPath.row];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.textLabel.text = [course objectAtIndex:1];
        if(![self.accessibilityValue isEqualToString:@"lessonPopover"])
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
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
    if (_popover) {
        return 1;
    }
    else{
        return [[[session client] courses]count];
    }
    //return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_popover) {
        return [[[session tutor] courses] count];
    }
    else{
        NSDictionary *tutor = [[[session client] courses] objectAtIndex:section];
        NSArray *courses = [tutor objectForKey:@"courses"];
        //return [[tutor objectForKey:@"courses"] count];
        return [courses count];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_popover) {
        return @"";
    }
    else{
        NSDictionary *tutor = [[[session client] courses] objectAtIndex:section];
        NSString *status = @"";
        NSArray *courses = [tutor objectForKey:@"courses"];
        if ([courses count] == 0) {
            status = @"(No courses)";
        }
        return [NSString stringWithFormat:@"%@ %@", [tutor objectForKey:@"tutorname"], status];
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //onclick for each object, put to label for example
    
    if (_popover) {
        Course *course = [[Course alloc] init];
        course.courseID = [[[[[session tutor] courses]objectAtIndex:indexPath.row]objectForKey:@"CourseID"] intValue];
        course.name = [[[[session tutor] courses]objectAtIndex:indexPath.row]objectForKey:@"CourseName"];
        
        [self.delegate sendBackCourse:course];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
    
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
    _scrollPosition = tableView.contentOffset.y;
    _indexPath = indexPath;
    _pushed = YES;
}

//MARGINED TABLE VIEW
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_popover)
        [Tools marginedtableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_popover)
        return nil;
    
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
    if(_popover)
        return false;
    
    return 50;
}

- (void) finished:(NSString *)status withArray:(NSArray *)array;
{
    if (_popover) {
        [[session tutor] setCourses:array];
        [self.tableView reloadData];
    }
    else{
    
        [[session client] setCourses:array];
        [self.tableView reloadData];
        if(_pushed){
            [self.tableView selectRowAtIndexPath:_indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

            [self.tableView setContentOffset:CGPointMake(0, _scrollPosition)];
            [self.tableView deselectRowAtIndexPath:_indexPath animated:YES];
        }
    
    }
    [Tools hideLoaderFromView:self.view];
}

@end
