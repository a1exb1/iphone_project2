//
//  AgendaViewController.m
//  testGit
//
//  Created by Alex Bechmann on 06/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "AgendaViewController.h"
#import "Tools.h"
#import "indexViewController.h"

@interface AgendaViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

@implementation AgendaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)jsonRequestGetAgenda
{
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=lessonsbytutoranddate&id=%d&date=%@&ts=%f", 2, @"06/05/2014", [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_mainTableView addPullToRefreshWithActionHandler:^{
        [self jsonRequestGetAgenda];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    _tutor = [[Tutor alloc] init];
    [_tutor setTutorID:2];
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [Tools showLoader];
    [self jsonRequestGetAgenda];
    
    [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andBackground:nil andTint:[Tools colorFromHexString:@"#4473b4"] theme:@"light"];
    
    //pVC.navigationController.navigationBar
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
    return [_lessons count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:@"cell"];
    
    NSString* str = [[_lessons objectAtIndex:indexPath.row] objectForKey:@"LessonDateTime"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSDate* lessonDate = [formatter dateFromString:str];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:lessonDate];
    NSInteger lessonDateHour = [components hour];
    NSInteger lessonDateMinute = [components minute];
    
    cell.textLabel.text = [[_lessons objectAtIndex:indexPath.row] objectForKey:@"StudentName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ at %02li:%02li (%i minutes)",
                                 [[_lessons objectAtIndex:indexPath.row] objectForKey:@"CourseName"],
                                 lessonDateHour,
                                 lessonDateMinute,
                                 [[[_lessons objectAtIndex:indexPath.row] objectForKey:@"Duration"] intValue]
                                 ];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _studentCourseLinkSender = [[StudentCourseLink alloc] init];
    [_studentCourseLinkSender setStudentCourseLinkID: [[[_lessons objectAtIndex:indexPath.row] objectForKey:@"LessonID"] intValue]];
    [_studentCourseLinkSender setTutor:_tutor];
    
    NSString* str = [[_lessons objectAtIndex:indexPath.row] objectForKey:@"LessonDateTime"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [_studentCourseLinkSender setDateTime:[formatter dateFromString:str]];
    
    Course *course = [[Course alloc]init];
    [course setCourseID:[[[_lessons objectAtIndex:indexPath.row] objectForKey:@"CourseID"] intValue]];
    [course setName:[[_lessons objectAtIndex:indexPath.row] objectForKey:@"CourseID"]];

    indexViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"dayView"];
    view.studentCourseLink = _studentCourseLinkSender;
    
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
    [_mainTableView.pullToRefreshView stopAnimating];
    [Tools hideLoader];
    
    _lessons = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];    
    [self.mainTableView reloadData];
    
    if ([_lessons count] == 0) {
        _statusLbl.hidden = NO;
        _statusLbl.text = @"No lessons";
        [_mainTableView setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
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