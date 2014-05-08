//
//  editCoursesListViewController.m
//  testGit
//
//  Created by Alex Bechmann on 03/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "editCoursesListViewController.h"
#import "saveCourseViewController.h"
#import "Tools.h"

@interface editCoursesListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

@implementation editCoursesListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    _data = [[NSMutableData alloc]init];
    _courses = [[NSArray alloc] init];
    [_mainTableView reloadData];
    
    [Tools showLoader];
    //
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=coursesbytutor&id=%li&ts=%f", [_tutor tutorID], [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:[Tools colorFromHexString:@"#57AD2C"] andTint:[UIColor whiteColor] theme:@"dark"];
}

- (void)viewDidAppear:(BOOL)animated {
    
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UIBarButtonItem *plusBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plus)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:plusBtn, nil]];
    
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
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.title = @"Edit a course";
    
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [_mainTableView addPullToRefreshWithActionHandler:^{
        NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=coursesbytutor&id=%li&ts=%f", [_tutor tutorID], [[NSDate date] timeIntervalSince1970]];
        NSURL *url = [NSURL URLWithString: urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
        
    }];
    
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
    cell.detailTextLabel.text = @"Edit the course's details";
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
    [Tools hideLoader];
    [_mainTableView.pullToRefreshView stopAnimating];
    
    _courses = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    [self.mainTableView reloadData];
    
    if ([_courses count] == 0) {
        _statusLbl.text = @"No courses, click the plus to add one";
        _statusLbl.hidden = NO;
        [_mainTableView setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        _statusLbl.hidden = YES;
        [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [_mainTableView.pullToRefreshView stopAnimating];
    [Tools hideLoader];
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
