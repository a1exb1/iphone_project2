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
#import "Session.h"

@interface AgendaViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@end

extern Session *session;

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

-(void)reloadData
{
    if(_editing)
    {
        _keepEditing = YES;
    }
    _indexPath= [self.mainTableView indexPathForSelectedRow];
    [self jsonRequestGetAgenda];
    
    //if (selection) {
    // [self.mainTableView deselectRowAtIndexPath:selection animated:YES];
    //}
}

-(void)jsonRequestGetAgendaFromSwitch
{
    self.navigationItem.rightBarButtonItem = nil;
    _NSURLType = 0;
    
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    _statusLbl.hidden = YES;
    
    calendar = [NSCalendar currentCalendar];
    components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:_dayDate]; // Get necessary date components
    
    dd = (int)[components day]; //gives you day
    mm = (int)[components month]; //gives you month
    yy = (int)[components year]; // gives you year
    
    _data = [[NSMutableData alloc]init];
    _lessons = [[NSArray alloc] init];
    //[_mainTableView reloadData];
    
    NSString *dateString = [[NSString alloc] initWithFormat:@"%02d/%02d/%i", dd, mm, yy ];
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=lessonsbytutoranddate&id=%li&date=%@&ts=%f", [[session tutor] tutorID], dateString, [[NSDate date] timeIntervalSince1970]];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    //NSURLConnection *connection = [NSURLConnection sendAsynchronousRequest:request queue:nil completionHandler:[self connectionDidFinishLoading:connection]];

}

-(void)jsonRequestGetAgenda
{
    self.navigationItem.rightBarButtonItem = nil;
    _NSURLType = 0;
    
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    _statusLbl.hidden = YES;
    
    calendar = [NSCalendar currentCalendar];
    components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:_dayDate]; // Get necessary date components
    
    dd = (int)[components day]; //gives you day
    mm = (int)[components month]; //gives you month
    yy = (int)[components year]; // gives you year
    
    _data = [[NSMutableData alloc]init];
    _lessons = [[NSArray alloc] init];
    //[_mainTableView reloadData];
    
    NSString *dateString = [[NSString alloc] initWithFormat:@"%02d/%02d/%i", dd, mm, yy ];
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=lessonsbytutoranddate&id=%li&date=%@&ts=%f", [[session tutor] tutorID], dateString, [[NSDate date] timeIntervalSince1970]];
    
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
    
    _dayDate = [[NSDate alloc] init];
    _dayDate = [NSDate date];
    
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    
    //[self.dayPicker setStartDate:[NSDate dateFromDay:28 month:9 year:2013] endDate:[NSDate dateFromDay:5 month:10 year:2013]];
    //[Tools showLightLoader];
    
    //    if ( [Tools isIpad] )
    //    {
    //        [Tools addECSlidingDefaultSetupWithViewController:self];
    //        [[session client] setClientID:1];
    //        [[session client] setPremium:0];
    //        [[session client] setClientUserName:@"Test"];
    //        [[session tutor] setTutorID:3];
    //        [[session tutor] setAccountType:0];
    //    }
    
    _clipboardItem = self.navigationItem.rightBarButtonItem;
    
    
}

- (void)viewDidLayoutSubviews {
    _mainTableView.frame = CGRectMake(0,60, self.view.frame.size.width, self.view.frame.size.height - 60);
    _datePicker.frame = CGRectMake(0, 64, self.view.frame.size.width, _datePicker.frame.size.height);
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
    
    if ( [Tools isIpad]  )
    {
        //NSDate *today = [NSDate date]; //Get a date object for today's date
        NSCalendar *c = [NSCalendar currentCalendar];
        NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                               inUnit:NSMonthCalendarUnit
                              forDate:_dayDate];
        [self.datePicker fillDatesFromDate:firstDateOfMonth.date numberOfDays:days.length];
    }
    else{
        [self.datePicker fillDatesFromDate:firstDayOfTheWeek numberOfDays:7];
    }
    
    
    
    NSDateComponents *currentDayOfWeek = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:_dayDate];
    
    //NSLog(@"we're here curreent weekday = %ld", (long)[currentDayOfWeek weekday]);
    //[self.datepicker fillCurrentYear];
    
    if ( [Tools isIpad]  )
    {
        NVDate *dayDate = [[NVDate alloc] initUsingDate:_dayDate];
        [self.datePicker selectDateAtIndex:(dayDate.day -1)];
    }
    else{
        if((long)[currentDayOfWeek weekday] == 1){
            [self.datePicker selectDateAtIndex:([currentDayOfWeek weekday] +5)];
        }
        else{
            [self.datePicker selectDateAtIndex:([currentDayOfWeek weekday] -2)];
        }
    }
    
    [Tools showLightLoaderWithView:self.navigationController.view];
}

- (void)updateSelectedDate
{
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEEddMMMM" options:0 locale:nil];
    
    //NSLog(@"%@", [formatter stringFromDate:self.datePicker.selectedDate]);
    
    [self finishedAttendanceBtn];
    
    if(_counter > 0){
        _dayDate = self.datePicker.selectedDate;
        [Tools showLightLoaderWithView:self.navigationController.view];
        [self jsonRequestGetAgenda];
        
        
    }
    _counter++;
    
}


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

-(void)prepareForAttendance{
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishedAttendanceBtn)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:doneBtn, nil]];
    _editing = true;
    [_mainTableView reloadData];
    //[_mainTableView setEditing:YES animated:YES];
    if(_indexPath >= 0)
    {
        [_mainTableView selectRowAtIndexPath:_indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
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
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishedAttendanceBtn)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:doneBtn, nil]];
    if(_keepEditing == NO)
    {
        _editing = false;
        UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithImage:[_clipboardItem image] style:[_clipboardItem style] target:self action:@selector(prepareForAttendance)];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:editBtn, nil]];
    }
    
    [_mainTableView reloadData];
    if(_indexPath >= 0)
    {
        [_mainTableView selectRowAtIndexPath:_indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)finishedAttendanceBtn{
    _keepEditing = NO;
    [self finishedAttendance];
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", [[_lessons objectAtIndex:indexPath.row] objectForKey:@"StudentName"], [[_lessons objectAtIndex:indexPath.row] objectForKey:@"CourseName"]];
    
    NSString *statusString = @"";
    if ([[[_lessons objectAtIndex:indexPath.row] objectForKey:@"Status"] intValue] == 0) {
        statusString = @"Attendence not set";
    }
    else if ([[[_lessons objectAtIndex:indexPath.row] objectForKey:@"Status"] intValue] == 1) {
        statusString = @"Cancelled";
    }
    else if ([[[_lessons objectAtIndex:indexPath.row] objectForKey:@"Status"] intValue] == 2) {
        statusString = @"Absent";
    }
    else if ([[[_lessons objectAtIndex:indexPath.row] objectForKey:@"Status"] intValue] == 3) {
        statusString = @"Present";
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%02li:%02li (%i min) • %@",
                                 (long)lessonDateHour,
                                 (long)lessonDateMinute,
                                 [[[_lessons objectAtIndex:indexPath.row] objectForKey:@"Duration"] intValue],
                                 statusString
                                 ];
    
    if(_editing){
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchview;
        switchview.tag = indexPath.row;
        [switchview addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
        if ([[[_lessons objectAtIndex:indexPath.row] objectForKey:@"Status"] intValue] == 3) {
            [switchview setOn:YES animated:NO];
        }
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)updateSwitchAtIndexPath: (UISwitch *) attendenceSwitch{
    int status = 2;
    if ([attendenceSwitch isOn]) {
        status = 3;
    }
    
    [Tools showLightLoaderWithView:self.navigationController.view];
    _NSURLType = 1;
    _keepEditing = YES;
    
    long lessonid = [[[_lessons objectAtIndex:attendenceSwitch.tag] objectForKey:@"LessonID"] intValue] ;
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=lessonstatus&id=%li&status=%i&ts=%f", lessonid, status, [[NSDate date] timeIntervalSince1970]];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if([Tools isIpad])
    {
        if(!_editing){
            [self selectRowAtRow:(int)indexPath.row];
        }
        else{
            NSIndexPath*    selection = [self.mainTableView indexPathForSelectedRow];
            [self.mainTableView deselectRowAtIndexPath:selection animated:YES];
            [_mainTableView selectRowAtIndexPath:_indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        
    }
    else{
        indexViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"dayView"];
        view.lesson = _lessonSender;
        
        if(!_editing){
            [self.navigationController pushViewController:view animated:YES];
        }
        else{
            NSIndexPath*    selection = [self.mainTableView indexPathForSelectedRow];
            [self.mainTableView deselectRowAtIndexPath:selection animated:YES];
            [_mainTableView selectRowAtIndexPath:_indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
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
    [Tools hideLoaderFromView:self.navigationController.view];
    
    //GET DATA
    if (_NSURLType == 0) {
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
            //if(_keepEditing == NO)
            //{
            [self finishedAttendance];
            //}
            
            if(_indexPath >= 0)
            {
                [_mainTableView selectRowAtIndexPath:_indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self selectRowAtRow:(int)_indexPath.row];
            }
            
            if([Tools isIpad])
            {
                if(!_editing &&
                   [_lessons count] > 0 &&
                   ![session hasSetAgendaToDetail]){ // NEEDS to check for current lesson and only run at start of application - if has run once, needs to know which row to go to. + select table row
                    
                    int lNo = 0;
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lNo inSection:0];
                    [_mainTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                    
                    //[self tableView: _mainTableView didDeselectRowAtIndexPath:indexPath];
                    
                    [self selectRowAtRow:lNo];
                    
                    [session setHasSetAgendaToDetail: YES];
                    _indexPath = [NSIndexPath indexPathForRow:lNo inSection:0];
                }
                
                
                
            }
        }
    }
    
    //SAVE ATTENDANCE
    else if (_NSURLType == 1) {
        [Tools showLightLoaderWithView:self.navigationController.view];
        [self jsonRequestGetAgendaFromSwitch];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [Tools hideLoaderFromView:self.navigationController.view];
    [_mainTableView.pullToRefreshView stopAnimating];
}

-(void)selectRowAtRow:(int)row
{
    _indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    _lessonSender = [[Lesson alloc] init];
    [_lessonSender setLessonID: [[[_lessons objectAtIndex:row] objectForKey:@"LessonID"] intValue]];
    [_lessonSender setTutor:_tutor];
    
    NSString* str = [[_lessons objectAtIndex:row] objectForKey:@"LessonDateTime"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [_lessonSender setDateTime:[formatter dateFromString:str]];
    [_lessonSender setDuration:[[[_lessons objectAtIndex:row] objectForKey:@"Duration"] intValue]];
    [_lessonSender setStatus:[[[_lessons objectAtIndex:row] objectForKey:@"Status"] intValue]];
    
    Course *course = [[Course alloc]init];
    [course setCourseID:[[[_lessons objectAtIndex:row] objectForKey:@"CourseID"] intValue]];
    [course setName:[[_lessons objectAtIndex:row] objectForKey:@"CourseName"]];
    [_lessonSender setCourse:course];
    
    Student *student = [[Student alloc]init];
    [student setStudentID:[[[_lessons objectAtIndex:row] objectForKey:@"StudentID"] intValue]];
    [student setName:[[_lessons objectAtIndex:row] objectForKey:@"StudentName"]];
    [student setPhone:[[_lessons objectAtIndex:row] objectForKey:@"Telephone"]];
    [_lessonSender setStudent:student];
    
    [self.detailViewController.navigationController popToViewController:[self.detailViewController.navigationController.viewControllers objectAtIndex:0] animated:NO];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    DetailViewController *controller = self.detailViewController;
    
    
    indexViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"dayView"];
    
    //[controller performSegueWithIdentifier: @"toAgendaFromSplit" sender: controller];
    
    view.lesson = _lessonSender;
    [view changed];
    view.agendaDelegate = self;
    
    [controller.navigationController pushViewController:view animated:NO];
    
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
