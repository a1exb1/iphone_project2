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
#import "NVDate.h"
#import "Client.h"

@interface AgendaViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@end

extern Client *client;

NSCalendar* calendar;
NSDateComponents* components;
int dd;
int mm;
int yy;
NSArray *months;
NSArray *daysOfWeekArray;

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
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    _statusLbl.hidden = YES;
    
    calendar = [NSCalendar currentCalendar];
    components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:_dayDate]; // Get necessary date components
    
    dd = (int)[components day]; //gives you day
    mm = (int)[components month]; //gives you month
    yy = (int)[components year]; // gives you year
    
    _data = [[NSMutableData alloc]init];
    _lessons = [[NSArray alloc] init];
    [_mainTableView reloadData];
    
    NSString *dateString = [[NSString alloc] initWithFormat:@"%02d/%02d/%i", dd, mm, yy ];
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=lessonsbytutoranddate&id=%li&date=%@&ts=%f", [_tutor tutorID], dateString, [[NSDate date] timeIntervalSince1970]];
    
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
    
    [self finishedAttendance];
    
    _dayDate = [[NSDate alloc] init];
    _dayDate = [NSDate date];
    
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    
    //[self.dayPicker setStartDate:[NSDate dateFromDay:28 month:9 year:2013] endDate:[NSDate dateFromDay:5 month:10 year:2013]];
    [Tools showLoader];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    _counter = 0;
    
    //[self.dayPicker setCurrentDate:_dayDate animated:NO];
    //[NSDate dateFromDay:3 month:10 year:2013]

    //NVDate *agendaDate = [[NVDate alloc] initUsingDate:_dayDate];
    
    NVDate *firstDateOfMonth = [[NVDate alloc] initUsingDate:_dayDate];
    [firstDateOfMonth firstDayOfMonth];
    NVDate *lastDateOfMonth = [[NVDate alloc] initUsingDate:_dayDate];
    [lastDateOfMonth lastDayOfMonth];
    
    [self.dayPicker setStartDate:[NSDate dateFromDay:[firstDateOfMonth day] month:[firstDateOfMonth month] year:[firstDateOfMonth year]] endDate:[NSDate dateFromDay:[lastDateOfMonth day] month:[lastDateOfMonth month] year:[lastDateOfMonth year]]];
    //[NSDate dateFromDay:28 month:9 year:2013]
    [self.dayPicker setCurrentDate:_dayDate animated:NO];
    //[self.dayPicker setCurrentDate:[NSDate dateFromDay:3 month:10 year:2013] animated:NO];
    
    _tutor = [[Tutor alloc] init];
    [_tutor setTutorID:3];
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
   
    
    [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:nil andTint:[Tools colorFromHexString:@"#4473b4"] theme:@"light"];
    //red e5534b
    //blue 4473b4
    
    //self.dayPicker.bottomBorderColor = [Tools colorFromHexString:@"#4473b4"];
    
    //self.mainTableView.frame = CGRectMake(0, self.dayPicker.frame.origin.y + self.dayPicker.frame.size.height, self.mainTableView.frame.size.width, self.view.bounds.size.height-self.dayPicker.frame.size.height);
    

    
    [self.datePicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
    
    //    [self.datepicker fillDatesFromCurrentDate:14];
    //[self.datePicker fillCurrentWeek];
    //    [self.datepicker fillCurrentMonth];

    //NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"GB"]];

    NSDateComponents* comps = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:_dayDate];
    
    [comps setWeekday:2]; // 2: monday
    NSDate *firstDayOfTheWeek = [calendar dateFromComponents:comps];

    [self.datePicker fillDatesFromDate:firstDayOfTheWeek numberOfDays:7];
    
    NSDateComponents *currentDayOfWeek = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:_dayDate];
    
    //NSLog(@"we're here curreent weekday = %ld", (long)[currentDayOfWeek weekday]);
    //[self.datepicker fillCurrentYear];
    
    if((long)[currentDayOfWeek weekday] == 1){
        [self.datePicker selectDateAtIndex:([currentDayOfWeek weekday] +5)];
    }
    else{
        [self.datePicker selectDateAtIndex:([currentDayOfWeek weekday] -2)];
    }

    [Tools showLoader];
    [self jsonRequestGetAgenda];
}

- (void)updateSelectedDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEEddMMMM" options:0 locale:nil];
    
    //NSLog(@"%@", [formatter stringFromDate:self.datePicker.selectedDate]);
        
    if(_counter > 0){
        _dayDate = self.datePicker.selectedDate;
        [Tools showLoader];
        [self jsonRequestGetAgenda];
        
        
    }
    _counter++;
    
}

//- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayNameLabelInDay:(MZDay *)day
//{
//    return [self.dateFormatter stringFromDate:day.date];
//}
//
//- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayLabelInDay:(MZDay *)day
//{
//    return @"hi";
//}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    months = [[NSArray alloc] initWithObjects:
              @"",
              @"January",
              @"February",
              @"March",
              @"April",
              @"May",
              @"June",
              @"July",
              @"August",
              @"September",
              @"October",
              @"November",
              @"December",
              nil];
    
    daysOfWeekArray = [[NSArray alloc] initWithObjects:
                       @"",
                       @"Monday",
                       @"Tuesday",
                       @"Wednesday",
                       @"Thursday",
                       @"Friday",
                       @"Saturday",
                       @"Sunday",
                       nil];
    
    NVDate *agendaDate = [[NVDate alloc] initUsingDate:_dayDate];
    return [NSString stringWithFormat:@"%i %@ %ld", (int)[agendaDate day], [months objectAtIndex:[agendaDate month]], (long)[agendaDate year]];
}

//- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
//{
//    //NSLog(@"Did select day %@ ",day.date);
//    _dayDate = day.date;
//    [self jsonRequestGetAgenda];
//    
//    //[self.tableData addObject:day];
//    //[self.tableView reloadData];
//}

//- (void)dayPicker:(MZDayPicker *)dayPicker willSelectDay:(MZDay *)day
//{
//    NSLog(@"Will select day %@",day.day);
//}



-(void)prepareForAttendance{
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishedAttendance)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:doneBtn, nil]];
    _editing = true;
    [_mainTableView reloadData];
    //[_mainTableView setEditing:YES animated:YES];
}

-(IBAction)selectDate{
    
    SelectDateViewController *view = [[SelectDateViewController alloc] initWithNibName:@"SelectDateViewController" bundle:nil];
    //    window.rootViewController = viewController;
    //    [window makeKeyAndVisible];
    //    indexViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"dayView"];
    //    view.lesson = _lessonSender;
    view.selectDateDelegate = self;
    view.previousDate = _dayDate;
    [UIView animateWithDuration:0.35
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:view animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
    
    //[self.navigationController pushViewController:view animated:YES];
}


-(void)finishedAttendance{
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"glyphicons_029_notes_2.png"] style:UIBarButtonItemStylePlain target:self action:@selector(prepareForAttendance)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:editBtn, nil]];
    _editing = false;
    [_mainTableView reloadData];
    
    //[_mainTableView setEditing:NO animated:YES];
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
    return 40;
    
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
                                 (long)lessonDateHour,
                                 (long)lessonDateMinute,
                                 [[[_lessons objectAtIndex:indexPath.row] objectForKey:@"Duration"] intValue]
                                 ];
    
    if(_editing){
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchview;
        switchview.tag = indexPath.row;
        [switchview addTarget:self action:@selector(updateSwitchAtIndexPath) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)updateSwitchAtIndexPath{

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _lessonSender = [[Lesson alloc] init];
    [_lessonSender setLessonID: [[[_lessons objectAtIndex:indexPath.row] objectForKey:@"LessonID"] intValue]];
    [_lessonSender setTutor:_tutor];
    
    NSString* str = [[_lessons objectAtIndex:indexPath.row] objectForKey:@"LessonDateTime"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [_lessonSender setDateTime:[formatter dateFromString:str]];
    
    Course *course = [[Course alloc]init];
    [course setCourseID:[[[_lessons objectAtIndex:indexPath.row] objectForKey:@"CourseID"] intValue]];
    [course setName:[[_lessons objectAtIndex:indexPath.row] objectForKey:@"CourseName"]];
    [_lessonSender setCourse:course];
    
    Student *student = [[Student alloc]init];
    [student setStudentID:[[[_lessons objectAtIndex:indexPath.row] objectForKey:@"StudentID"] intValue]];
    [student setName:[[_lessons objectAtIndex:indexPath.row] objectForKey:@"StudentName"]];
    [_lessonSender setStudent:student];
    
    indexViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"dayView"];
    view.lesson = _lessonSender;
    
    if(!_editing){
        [self.navigationController pushViewController:view animated:YES];
    }
    
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


-(void)sendDateToAgendaWithDate:(NSDate *) Date{
    _dayDate = Date;
    [self finishedAttendance];
    [self jsonRequestGetAgenda];
}

+(NSDate *)getFirstDayOfTheWeekFromDate:(NSDate *)givenDate
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:givenDate];
    
    [comps setWeekday:2]; // 2: monday
    NSDate *firstDayOfTheWeek = [calendar dateFromComponents:comps];
    [comps setWeekday:7]; // 7: saturday
    //NSDate *lastDayOfTheWeek = [calendar dateFromComponents:comps];
    
    return firstDayOfTheWeek;
}

+(NSDate *)getLastDayOfTheWeekFromDate:(NSDate *)givenDate
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:givenDate];
    
    [comps setWeekday:2]; // 2: monday
    //NSDate *firstDayOfTheWeek = [calendar dateFromComponents:comps];
    [comps setWeekday:7]; // 7: saturday
    NSDate *lastDayOfTheWeek = [calendar dateFromComponents:comps];
    
    return lastDayOfTheWeek;
}


@end
