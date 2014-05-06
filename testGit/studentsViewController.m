//
//  studentsViewController.m
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "studentsViewController.h"
#import "editStudentAndSlotViewController.h"
#import "editStudentViewController.h"
#import "viewAllStudentsViewController.h"
#import "NavigationBarTitleWithSubtitleView.h"
#import "Tools.h"

@interface studentsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *plusBtn;

@end

@implementation studentsViewController
NSArray *daysOfWeekArray;
NSMutableArray *viewStudentsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)plus:(id)sender
{
    Student *student = [[Student alloc] init];
    StudentCourseLink *studentCourseLink = [[StudentCourseLink alloc] init];
    
    
    [studentCourseLink setCourse: _course];
    //[student setStudentCourseLink: studentCourseLink];
    [_studentCourseLinkSender setStudent:student];
    //_studentSender = student;
    _sender = 1;
    [self performSegueWithIdentifier:@"studentsForCourseToStudentsList" sender:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    
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
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=studentsbycourse&id=%li&ts=%f", [_course courseID], [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    _sender = -1;
    
    viewStudentsArray = [[NSMutableArray alloc] init];
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    _data = [[NSMutableData alloc]init];
    _uniqueWeekdays = [[NSArray alloc]init];
    _students = [[NSArray alloc] init];
    [_mainTableView reloadData];
    _statusLbl.hidden = YES;
    //_statusLbl.text = @"Loading...";
    
    [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andBackground:[Tools colorFromHexString:@"#4473b4"] andTint:[UIColor whiteColor] theme:@"dark"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [Tools showLoader];
    //
    
    daysOfWeekArray = [[NSArray alloc] initWithObjects:
                                @"Sunday",
                                @"Monday",
                                @"Tuesday",
                                @"Wednesday",
                                @"Thursday",
                                @"Friday",
                                @"Saturday",
                                nil];
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    self.title = [_course name];
    
    _studentCourseLinkSender = [[StudentCourseLink alloc] init];
    [_studentCourseLinkSender setCourse: _course];
    
    Student *student = [[Student alloc] init];
    [_studentCourseLinkSender setStudent:student];
    [_studentCourseLinkSender setTutor:_tutor];
    
    [_mainTableView addPullToRefreshWithActionHandler:^{
        //[Tools showLoader];
        NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=studentsbycourse&id=%li&ts=%f", [_course courseID], [[NSDate date] timeIntervalSince1970]];
        NSURL *url = [NSURL URLWithString: urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }];
        
    UIBarButtonItem *plusBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plus)];
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:plusBtn, deleteBtn, nil]];
}

-(void)plus
{
    [self performSegueWithIdentifier:@"studentsForCourseToStudentsList" sender:self];
}

-(void)startEditingTable{
    [_mainTableView setEditing:YES animated:YES];
    UIBarButtonItem *plusBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plus)];
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(delete)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:plusBtn, deleteBtn, nil]];
    _editing = true;
}

-(void)endEditingTable{
    [_mainTableView setEditing:NO animated:YES];
    UIBarButtonItem *plusBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plus)];
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:plusBtn, deleteBtn, nil]];
    _editing = false;
}

-(void)delete
{
    if (_editing == true) {
        [self endEditingTable];
            }
    else{
        [self startEditingTable];
    }
}

//-(void)delete{
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //[_mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[Tools showLoader];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.studentIDSender = cell.accessibilityValue;
        NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
        sectionArray = [viewStudentsArray objectAtIndex:indexPath.section];
        
        StudentCourseLink *link = [[StudentCourseLink alloc] init];
        [link setStudentCourseLinkID:[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"StudentCourseLinkID"] intValue]];
        [link setWeekday:[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Weekday"] intValue]];
        [link setHour:[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Hour"] intValue]];
        [link setMins:[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Minute"] intValue]];
        [link setDuration:[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Duration"] intValue]];
        
        
        Student *student = [[Student alloc] init];
        [student setStudentID: [[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"StudentID"] intValue]];
        [student setName: [[sectionArray objectAtIndex:indexPath.row] objectForKey:@"StudentName"]];
        [link setStudent:student];
        
        NSLog(@"delete %li", [link StudentCourseLinkID]);

//        NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=studentcourselink&id=%li&delete=1&clientid=%i&ts=%f", [link StudentCourseLinkID], 1, [[NSDate date] timeIntervalSince1970]];
//        
//        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:
//                     NSASCIIStringEncoding];
//        
//        NSURL *url = [NSURL URLWithString: urlString];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        [NSURLConnection connectionWithRequest:request delegate:self];
        
        [self endEditingTable];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    int uniqueDay = [[_uniqueWeekdays objectAtIndex:section] intValue];
    NSString *uniqueDayString;
    uniqueDayString = [daysOfWeekArray objectAtIndex: uniqueDay];
    sectionName = uniqueDayString;
    
    return sectionName;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_uniqueWeekdays count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[viewStudentsArray objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:@"cell"];
    
    NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
    sectionArray = [viewStudentsArray objectAtIndex:indexPath.section];
    
    int weekdayFromJson = [[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Weekday"] intValue];
    NSString *weekday = [NSString stringWithFormat:@""];
    
    weekday = [daysOfWeekArray objectAtIndex: weekdayFromJson];
    int hour = [[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Hour"] intValue];
    int minute = [[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Minute"] intValue];
    int duration = [[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Duration"] intValue];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%02d:%02d (%02d minutes)", hour, minute, duration];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"StudentName"]];
    cell.accessibilityValue = [[sectionArray objectAtIndex:indexPath.row] objectForKey:@"StudentID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.studentIDSender = cell.accessibilityValue;
    NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
    sectionArray = [viewStudentsArray objectAtIndex:indexPath.section];
    
    [_studentCourseLinkSender setStudentCourseLinkID:[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"StudentCourseLinkID"] intValue]];
    [_studentCourseLinkSender setWeekday:[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Weekday"] intValue]];
    [_studentCourseLinkSender setHour:[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Hour"] intValue]];
    [_studentCourseLinkSender setMins:[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Minute"] intValue]];
    [_studentCourseLinkSender setDuration:[[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"Duration"] intValue]];
    
    
    Student *student = [[Student alloc] init];
    [student setStudentID: [[[sectionArray objectAtIndex:indexPath.row] objectForKey:@"StudentID"] intValue]];
    [student setName: [[sectionArray objectAtIndex:indexPath.row] objectForKey:@"StudentName"]];
    
    [_studentCourseLinkSender setStudent:student];
    _sender = 0;
    [self performSegueWithIdentifier:@"StudentsToEditStudentAndLink" sender:self];
    
}

-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc]init];
    _uniqueWeekdays = [[NSArray alloc]init];
    
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
    
    _students = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    _uniqueWeekdays = [_students valueForKeyPath:@"@distinctUnionOfObjects.Weekday"];
    
    //sort array numerically
    _uniqueWeekdays = [_uniqueWeekdays sortedArrayUsingDescriptors:
                       @[[NSSortDescriptor sortDescriptorWithKey:@"doubleValue"
                                                       ascending:YES]]];
    for (id weekday in _uniqueWeekdays) {
        NSMutableArray *listOfStudentsForArray = [[NSMutableArray alloc] init];
        for (id student in _students) {
            if([[student objectForKey:@"Weekday" ] isEqualToString:weekday]){
                [listOfStudentsForArray addObject:student];
            }
        }
        [viewStudentsArray addObject:listOfStudentsForArray];
    }
    [self.mainTableView reloadData];
        
    if ([_students count] == 0) {
        _statusLbl.hidden = NO;
        _statusLbl.text = @"No students, click the plus to add one";
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
    [Tools hideLoader];
    [_mainTableView.pullToRefreshView stopAnimating];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if (_sender == 1){
        viewAllStudentsViewController *item = segue.destinationViewController;
        item.studentCourseLink = self.studentCourseLinkSender;
    }
    else{
        editStudentAndSlotViewController *item = segue.destinationViewController;
        item.studentCourseLink = self.studentCourseLinkSender;
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
