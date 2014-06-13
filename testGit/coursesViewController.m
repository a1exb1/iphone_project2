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
#import "Session.h"

@interface coursesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

@implementation coursesViewController

extern Session *session;

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
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([Tools isIpad])
    {
        //_tutor = [session tutor];
        
    }
    
    if ([[session tutor] accountType] > 1) {
        [self.navigationItem setHidesBackButton:YES animated:NO];
        _tutor = [session tutor];
    }
    // Unselect the selected row if any
    NSIndexPath*    selection = [self.mainTableView indexPathForSelectedRow];
    if (selection) {
        [self.mainTableView deselectRowAtIndexPath:selection animated:YES];
    }
    
    _data = [[NSMutableData alloc]init];
    _courses = [[NSArray alloc] init];
    [_mainTableView reloadData];
    _statusLbl.hidden = YES;
    //_statusLbl.text = @"Loading...";
    
    if(![self.accessibilityValue isEqualToString:@"coursesPopover"])
    {
        [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:[Tools colorFromHexString:@"#57AD2C"] andTint:[UIColor whiteColor] theme:@"dark"];
        
        [_mainTableView addPullToRefreshWithActionHandler:^{
            //[Tools showLoader];
            //
            [self loadData];
        }];
        
    }
    else{
        self.navigationController.navigationBar.translucent = NO;
        self.navigationItem.rightBarButtonItems = nil;
        
        self.navigationController.view.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor = [UIColor clearColor];
    }
    
    
    [Tools showLoader];
    //
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=coursesbytutor&id=%li&ts=%f", [_tutor tutorID], [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    if(![self.accessibilityValue isEqualToString:@"coursesPopover"]){
        [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
        [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    
    
    
    //
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
//    NavigationBarTitleWithSubtitleView *navigationBarTitleView = [[NavigationBarTitleWithSubtitleView alloc] init];
//    [self.navigationItem setTitleView: navigationBarTitleView];
//    [navigationBarTitleView setTitleText:@"Courses"];
//    [navigationBarTitleView setDetailText:[_tutor name]];
    

    
    UIBarButtonItem *plusBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plus)];
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:plusBtn, editBtn, nil]];
    
    if(![self.accessibilityValue isEqualToString:@"coursesPopover"]){
        [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    
    
    
}

-(void)loadData
{
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=coursesbytutor&id=%li&ts=%f", [_tutor tutorID], [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
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
    
    cell.backgroundColor = [UIColor whiteColor];
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

    
//    if ([Tools isIpad])
//    {
////
//        [self.detailViewController.navigationController popToViewController:[self.detailViewController.navigationController.viewControllers objectAtIndex:0] animated:NO];
////        
//        self.detailViewController = (studentsViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
//        self.detailViewController.course = _courseSender;
//
//        studentsViewController *controller = self.detailViewController;
//        [controller loadData];
//        
//    }
    //else{
    if([self.accessibilityValue isEqualToString:@"coursesPopover"])
    {
        viewAllStudentsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"addStudentsList"];
        view.accessibilityValue = @"coursesPopover";
        
        StudentCourseLink *link = [[StudentCourseLink alloc] init];
        [link setTutor:[session tutor]];
        [link setCourse:_courseSender];
        view.studentCourseLink = link;
        [self.navigationController pushViewController:view animated:YES];
    }
    else{
        studentsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"students"];
        view.course = _courseSender;
        [self.navigationController pushViewController:view animated:YES];
    }
    
    //}
    //studentsDetailView
    
    
    
    
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
        if(![self.accessibilityValue isEqualToString:@"coursesPopover"]){
            [_mainTableView setBackgroundColor:[UIColor whiteColor]];
        }
        
    }
    else{
        if(![self.accessibilityValue isEqualToString:@"coursesPopover"]){
            [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        }
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
