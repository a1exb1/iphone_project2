//
//  coursesViewController.m
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "coursesViewController.h"
#import "studentsViewController.h"
#import "editCoursesListViewController.h"
#import "saveCourseViewController.h"
#import "NavigationBarTitleWithSubtitleView.h"
#import "Tools.h"

@interface coursesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

@implementation coursesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [Tools showLoader];
    //
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=coursesbytutor&id=%li&ts=%f", [_tutor tutorID], [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Unselect the selected row if any
    NSIndexPath*    selection = [self.mainTableView indexPathForSelectedRow];
    if (selection) {
        [self.mainTableView deselectRowAtIndexPath:selection animated:YES];
    }
    
    [Tools showLoader];
    
    _data = [[NSMutableData alloc]init];
    _courses = [[NSArray alloc] init];
    [_mainTableView reloadData];
    _statusLbl.hidden = YES;
    //_statusLbl.text = @"Loading...";
    UIColor *barColor = [Tools colorFromHexString:@"#57AD2C"];
    self.navigationController.navigationBar.barTintColor = barColor;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    NavigationBarTitleWithSubtitleView *navigationBarTitleView = [[NavigationBarTitleWithSubtitleView alloc] init];
    [self.navigationItem setTitleView: navigationBarTitleView];
    [navigationBarTitleView setTitleText:@"Courses"];
    [navigationBarTitleView setDetailText:[_tutor name]];
    
    UIBarButtonItem *plusBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plus)];
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:plusBtn, editBtn, nil]];
    
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [_mainTableView addPullToRefreshWithActionHandler:^{
        [Tools showLoader];
        //
        NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=coursesbytutor&id=%li&ts=%f", [_tutor tutorID], [[NSDate date] timeIntervalSince1970]];
        NSURL *url = [NSURL URLWithString: urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }];

    UIColor *barColor = [Tools colorFromHexString:@"#57AD2C"];
    self.navigationController.navigationBar.barTintColor = barColor;
    
}

-(void)plus{
    _courseSender = [[Course alloc] init];
    saveCourseViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"saveCourse"];
    view.course = _courseSender;
    view.tutor = _tutor;
    [self.navigationController pushViewController:view animated:YES];
    
}

-(void)edit{
    editCoursesListViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"editCoursesList"];
    view.tutor = _tutor;
    [self.navigationController pushViewController:view animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_courses count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [[_courses objectAtIndex:indexPath.row] objectForKey:@"CourseName"];
    cell.accessibilityValue = [[_courses objectAtIndex:indexPath.row] objectForKey:@"CourseID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //onclick for each object, put to label for example
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    self.courseNameSender = cell.textLabel.text;
//    self.courseIDSender = cell.accessibilityValue;
    //self.itemNameSender = cell.textLabel.text;
    
    _courseSender = [[Course alloc] init];
    [_courseSender setTutorID:[_tutor tutorID]];
    [_courseSender setCourseID:[cell.accessibilityValue intValue]];
    [_courseSender setName:cell.textLabel.text];
    
    [self performSegueWithIdentifier:@"CoursesToStudents" sender:self];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *sectionName = [NSString stringWithFormat:@"%@", _tutorName];
//
//    
//    return sectionName;
//}

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
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [Tools hideLoader];
    [_mainTableView.pullToRefreshView stopAnimating];
    
    _courses = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    [self.mainTableView reloadData];
    
    if ([_courses count] == 0) {
        _statusLbl.hidden = NO;
        _statusLbl.text = @"No courses, click the plus to add one";
        [_mainTableView setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        _statusLbl.hidden = YES;
        
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [Tools hideLoader];
    [_mainTableView.pullToRefreshView stopAnimating];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    studentsViewController *item = segue.destinationViewController;
    item.course = _courseSender;
    item.tutor = _tutor;
//    item.courseName = self.courseNameSender;
//    item.courseID = self.courseIDSender;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
