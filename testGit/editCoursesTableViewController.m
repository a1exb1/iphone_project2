//
//  editCoursesTableViewController.m
//  PlanIt!
//
//  Created by Alex Bechmann on 11/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "editCoursesTableViewController.h"

@interface editCoursesTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

@implementation editCoursesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    _data = [[NSMutableData alloc]init];
    _courses = [[NSArray alloc] init];
    [self.tableView reloadData];
    
    //[Tools showLoader];
    //
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=coursesbytutor&id=%li&ts=%f", [_tutor tutorID], [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    
    
    if([Tools isIpad])
    {
        [self.navigationItem setHidesBackButton:YES];
    }
    else{
        [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:[Tools colorFromHexString:@"#57AD2C"] andTint:[UIColor whiteColor] theme:@"dark"];
    }
    
   [self getJson];
}

- (void)viewDidAppear:(BOOL)animated {
    
    
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UIBarButtonItem *plusBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plus)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:plusBtn, nil]];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)plus{
    _courseSender = [[Course alloc] init];
    saveCourseViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"saveCourse"];
    view.course = _courseSender;
    view.tutor = _tutor;
    [self.navigationController pushViewController:view animated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"Edit a course";
    
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=coursesbytutor&id=%li&ts=%f", [_tutor tutorID], [[NSDate date] timeIntervalSince1970]];
        NSURL *url = [NSURL URLWithString: urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
        
    }];
    
}

-(void)getJson
{
    _data = [[NSMutableData alloc]init];
    _courses = [[NSArray alloc] init];
    [self.tableView reloadData];
    [Tools showLoaderWithView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=coursesbytutor&id=%li&ts=%f", [_tutor tutorID], [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

//
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if ([_courses count] == 0) {
//        return @"No courses, click the plus to add one";
//    }
//    else{
//        return @"";
//    }
//    
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_courses count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [[_courses objectAtIndex:indexPath.row] objectForKey:@"CourseName"];
    cell.accessibilityValue = [[_courses objectAtIndex:indexPath.row] objectForKey:@"CourseID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(![Tools isIpad]){
        cell.detailTextLabel.text = @"Edit the course's details";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //onclick for each object, put to label for example
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //self.tutorIDSender = cell.accessibilityValue;
    //self.tutorNameSender = cell.textLabel.text;
    //[self performSegueWithIdentifier:@"TutorsToCourses" sender:self];
    
    _courseSender = [[Course alloc] init];
    [_courseSender setCourseID:[cell.accessibilityValue intValue]];
    [_courseSender setName:cell.textLabel.text];
    
    saveCourseViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"saveCourse"];
    view.course = self.courseSender;
    view.tutor = _tutor;
    [self.navigationController pushViewController:view animated:YES];
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
    [Tools hideLoaderFromView:self.view];
    [self.tableView.pullToRefreshView stopAnimating];
    
    _courses = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    [self.tableView reloadData];
    
    if ([_courses count] == 0) {
        _statusLbl.text = @"No courses, click the plus to add one";
        _statusLbl.hidden = NO;
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        _statusLbl.hidden = YES;
        [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [self.tableView.pullToRefreshView stopAnimating];
    [Tools hideLoaderFromView:self.view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
