//
//  calenderViewController.m
//  PlanIt!
//
//  Created by Alex Bechmann on 28/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "calenderViewController.h"

@interface calenderViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *lockedUIButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *unlockedUIButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *calenderUIButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *plusUIButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addLessonSlotBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editSlotsButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation calenderViewController

extern Session *session;

NSTimer *timer;

-(void)reloadWebView
{
    [_popover dismissPopoverAnimated:YES];
    [self loadUrl];
}


-(void)reload
{
    [self reloadWebView];
}

-(void)viewDidAppear:(BOOL)animated
{    
    if (_navigationPaneBarButtonItem)
        [self.navigationItem setLeftBarButtonItem:self.navigationPaneBarButtonItem animated:NO];
    
    [self setModalSize];
    [self loadUrl];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lockBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"744-locked-toolbar-selected.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(unlock)];
    _locked = YES;
    
    

    self.webView.delegate = self;
    
    if([self.accessibilityValue isEqualToString:@"calenderView"]){
        self.title = @"Calender";
        
        [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: nil andBackground: nil andTint:[Tools colorFromHexString:@"#b44444"] theme:@"light"];     //[Tools colorFromHexString:@"#b44444"]
    }
    else{
        self.title = @"Lesson slots";
        
        [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: nil andBackground:[Tools defaultNavigationBarColour] andTint:[Tools colorFromHexString:@"#57AD2C"] theme:@"light"];
    }

    [session setCalController:self];
    
    //[self.navigationItem setHidesBackButton:YES];
    
    if([self.accessibilityValue isEqualToString:@"calenderView"]){
        
        if(_date == NULL){
            _date = [[NSDate alloc] init];
        }
        
        [self sendDateToAgendaWithDate:_date];
    }
    else{
        
        //[self loadUrl];
    }
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"765-arrow-left-toolbar-selected.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    [self setModalSize];
    
    
    
}

-(void)done
{
    [_popover dismissPopoverAnimated:YES];
    [_calPopover dismissPopoverAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.monthCalenderDelegate sendDateToAgendaWithDate:NULL];
        [_menuDrawerDelegate deselectTableRow];
    }];
    
}



-(void)sendDateToAgendaWithDate:(NSDate *) Date
{
    _date = Date;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(400, 400, self.view.frame.size.width, self.view.frame.size.height)];
    _statusLbl = label;
    _statusLbl.text = @"Error with download";
    _statusLbl.accessibilityValue = @"statusLbl";
    for(UIView *view in self.view.subviews){
        if([view.accessibilityValue isEqualToString:@"statusLbl"]){
            [view removeFromSuperview];
        }
    }
    [self.view addSubview:_statusLbl];
    _statusLbl.hidden = YES;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"GB"]];
    
    NSDateComponents* comps = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:Date];
    
    [comps setWeekday:2]; // 2: monday
    _firstDateOfWeek = [calendar dateFromComponents:comps];
    
    [_calPopover dismissPopoverAnimated:YES];
    [self loadUrl];
    
}


-(void)previousWeek
{
    _c++;
    [_statusLbl removeFromSuperview];
    NVDate *date = [[NVDate alloc] initUsingDate:_date];
    [date nextDays:-7];
    _date = date.date;
    [self sendDateToAgendaWithDate:_date];
}

-(void)nextWeek
{
    _c++;
    [_statusLbl removeFromSuperview];
    NVDate *date = [[NVDate alloc] initUsingDate:_date];
    [date nextDays:7];
    _date = date.date;
    [self sendDateToAgendaWithDate:_date];
}

-(void)showNavigationBar
{
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 40;
    
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    //UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(done)];

    if ([self.accessibilityValue isEqualToString:@"calenderView"]) {
        //CALENDER
        UIBarButtonItem *addLessonsBtn = nil;
        addLessonsBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add to calender" style:UIBarButtonItemStylePlain target:self action:@selector(addLessons)];
        
        //UIBarButtonItem *calButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"851-calendar-toolbar-selected.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(selectDate:)];
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"765-arrow-left-toolbar-selected.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(previousWeek)];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"766-arrow-right-toolbar-selected.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(nextWeek)];
        
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] ;
        
        NSArray *segmentedControlsItems = [NSArray arrayWithObjects: @"Month", @"Week", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedControlsItems];
        segmentedControl.frame = CGRectMake(0, 0, 100, 30);
        [segmentedControl addTarget:self action:@selector(changeCalType) forControlEvents: UIControlEventValueChanged];
        segmentedControl.selectedSegmentIndex = 1;
        UIBarButtonItem *segmentButton = [[UIBarButtonItem alloc] initWithCustomView: segmentedControl];
        
        if(_lockBtn == nil){
            _lockBtn = [[UIBarButtonItem alloc ] init];
        }
        
        self.toolbarItems = [NSArray arrayWithObjects:refreshBtn, fixedSpace, _lockBtn, flex, segmentButton, flex, leftButton, fixedSpace,  rightButton, nil];
        
        
    }
    else{
        [self.navigationItem setRightBarButtonItem:_addLessonSlotBtn];
        self.toolbarItems = [NSArray arrayWithObjects:refreshBtn,fixedSpace,  _lockBtn, nil];
    }
    
    //if([self.accessibilityValue isEqualToString:@"calenderView"]){
        [self setNavigationBarSize];
    //}
    
}

-(void)changeCalType
{
    monthCalenderViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"monthCal"];
    view.dayDate = _date;
    view.monthCalenderDelegate = self.monthCalenderDelegate;
    view.dontReset = YES;
    [view drawSquaresWithDirection:3 andOldContainer:nil];
    self.navigationController.viewControllers = [[NSArray alloc] initWithObjects:view, nil];
}

-(void)setNavigationBarSize
{
    [self.navigationController setToolbarHidden:NO];
    if([self.accessibilityValue isEqualToString:@"calenderView"]){
        self.webView.frame = CGRectMake(0, -23, self.view.frame.size.width, self.view.frame.size.height);
    }
    else{
        self.webView.frame = CGRectMake(0, -23, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    
    _statusLbl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width,75);
    
    CGFloat verticalOffset = -27; //31 is same as default
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.rightBarButtonItem setBackgroundVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem.leftBarButtonItem setBackgroundVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    
    //DAY VIEWS
    for(UIView *view in self.navigationController.navigationBar.subviews){
        if([view.accessibilityValue isEqualToString:@"dayTitle"]){
            [view removeFromSuperview];
        }
    }
    
    float padding = self.view.frame.size.width * 0.09;
    //float labelContainer = self.view.frame.size.width - padding;
    float labelWidth = self.view.frame.size.width * 0.13;
    
    //float y = (top * height);
    //float width = (self.view.frame.size.width /7);
    //float left = 0;
    
    for (int i=0; i<7; i++) {
        float x = padding + (i*labelWidth);
        
        UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 37, labelWidth, 45)];
        dayLabel.text = [[Tools daysOfWeekArray] objectAtIndex:i];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.font = [UIFont fontWithName:nil size:13];
        dayLabel.textColor = [Tools colorFromHexString:@"#9b9b9b"];
        dayLabel.accessibilityValue = @"dayTitle";
        [self.navigationController.navigationBar addSubview:dayLabel];
    }
    
}

-(void)addLessons
{
    AddLessonsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"addLessonsView"];
    
    view.shouldClear = NO;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)hideNavigationBar
{    
    if ([self.accessibilityValue isEqualToString:@"calenderView"]) {
        //CALENDER
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width = 40;

        UIBarButtonItem *addLessonsBtn = nil;
        addLessonsBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add to calender" style:UIBarButtonItemStylePlain target:self action:@selector(addLessons)];
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"765-arrow-left-toolbar-selected.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(previousWeek)];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"766-arrow-right-toolbar-selected.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(nextWeek)];
        
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] ;
        
        NSArray *segmentedControlsItems = [NSArray arrayWithObjects: @"Month", @"Week", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedControlsItems];
        segmentedControl.frame = CGRectMake(0, 0, 100, 30);
        [segmentedControl addTarget:self action:@selector(changeCalType) forControlEvents: UIControlEventValueChanged];
        segmentedControl.selectedSegmentIndex = 1;
        UIBarButtonItem *segmentButton = [[UIBarButtonItem alloc] initWithCustomView: segmentedControl];
        
        self.toolbarItems = [NSArray arrayWithObjects: flex, segmentButton, flex, leftButton, fixedSpace,  rightButton, nil];

    }
    else{
        self.toolbarItems = nil;
    }
    
}

-(void)lock
{
    [_webView stringByEvaluatingJavaScriptFromString:@"lockScreen();"];
    _lockBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"744-locked-toolbar-selected.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(unlock)];
    _locked = YES;
    [self showNavigationBar];
}

-(void)unlock
{
    [_webView stringByEvaluatingJavaScriptFromString:@"unlockScreen();"];
    _lockBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"745-unlocked-toolbar.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(lock)];
     _locked = NO;
    [self showNavigationBar];
    
}

-(void)loadUrl
{
    self.statusLbl.hidden = YES;
    self.webView.hidden = YES;
        
    NVDate *fromDate = [[NVDate alloc] initUsingDate:_firstDateOfWeek];
    NSString *fromDateString = [[NSString alloc] initWithFormat:@"%0.2ld/%0.2ld/%ld", (long)fromDate.day, (long)fromDate.month, (long)fromDate.year];
    
    NVDate *toDate = [[NVDate alloc] initUsingDate:fromDate.date];
    [toDate nextDays:6];
    NSString *toDateString = [[NSString alloc] initWithFormat:@"%0.2ld/%0.2ld/%ld", (long)toDate.day, (long)toDate.month, (long)toDate.year];
    
    if([self.accessibilityValue isEqualToString:@"calenderView"])
    self.title = [NSString stringWithFormat:@"%@ - %@",fromDateString, toDateString];
    
    [self hideNavigationBar];
    [Tools showLightLoader];
    NSLog(@"%f", self.navigationController.view.frame.size.width);
    //[Tools showLightLoader];
    //[Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:nil andTint:nil theme:@"light"];
    
    NSString *urlString = [[NSString alloc] init];
    if([self.accessibilityValue isEqualToString:@"calenderView"]){
        urlString = [NSString stringWithFormat: @"http://lm.bechmann.co.uk/sections/frames/calender_items_week.aspx?&tutorid=%li&from=%@&to=%@&clientid=%li&auth=0CCAAC112", [[session tutor] tutorID], fromDateString, toDateString, [[session client] clientID]];
        
    }
    else{
        urlString = [NSString stringWithFormat: @"http://lm.bechmann.co.uk/sections/frames/lesson_slots.aspx?from=defaultlessontimes&tp=tutor&tutorid=%li&clientid=%li&auth=0CCAAC112", [[session tutor] tutorID], [[session client] clientID]];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    self.webView.tag = _c;
    [self.webView loadRequest:requestObj];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self setModalSize];
}

-(void)refresh
{
    [self loadUrl];
}

- (void)cancelWeb
{
    //NSLog(@"didn't finish loading within 20 sec");
    //[Tools hideLoader];
    //self.webView.hidden = NO;
    // do anything error
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %ld, %d %@", (long)webView.tag, _c, error);
    
    //_lockBtn = nil;
    [self showNavigationBar];
//    if(webView.tag == _c){
//        [Tools hideLoader];
//        self.statusLbl.hidden = NO;
//        self.statusLbl.center = self.view.center;
//    }
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // webView connected
    //timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
    
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
    if ([[url scheme] isEqualToString:@"toolbar"]) {
        
        NSString *prefix = @"toolbar://pano/tapped:";

        NSString *urlString = [[NSString alloc] initWithFormat:@"%@", url ];
        
        NSRange range = NSMakeRange(prefix.length,
                                          urlString.length - prefix.length);
        NSString *jsonString = [urlString substringWithRange:range];
        jsonString = [jsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSLog(@"%@", jsonDictionary);
        
        int scrollPosition = [[self.webView stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue];
        
        int y = [[jsonDictionary objectForKey:@"y"]intValue] + 75;
        y = y -scrollPosition;
        
        CGRect rect = CGRectMake([[jsonDictionary objectForKey:@"x"]intValue], y, 1, 1);
        
        if ([self.accessibilityValue isEqualToString:@"calenderView"]) {
            UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"lessonNavigationController"];
            newCalenderEventViewController *view = (newCalenderEventViewController *)navVC.topViewController;
            
            view.delegate = (id)self;
            view.dayDate = _date;
            
            Lesson *lesson = [[Lesson alloc] init];
            lesson.LessonID = [[jsonDictionary objectForKey:@"lessonid"]intValue];
            lesson.Duration = [[jsonDictionary objectForKey:@"lessonduration"]intValue];
            
            Course *course = [[Course alloc] init];
            course.courseID = [[jsonDictionary objectForKey:@"lessoncourseid"]intValue];
            course.name = [Tools base64Decode:[jsonDictionary objectForKey:@"lessoncoursename"]];
            lesson.course = course;
            
            Student *student = [[Student alloc] init];
            student.studentID = [[jsonDictionary objectForKey:@"lessonstudentid"]intValue];
            student.name = [Tools base64Decode:[jsonDictionary objectForKey:@"lessonstudentname"]];
            lesson.student = student;
            
            //NVDate *date = [[NVDate alloc] initUsingString:[jsonDictionary objectForKey:@"lessondate"] ];
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
            //[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
            NSDate *date = [dateFormatter dateFromString: [jsonDictionary objectForKey:@"lessondate"]];
            
            view.dayDate = date;
            lesson.dateTime = date;
            view.lesson = lesson;
            
            UIPopoverController *popController = [[UIPopoverController alloc] initWithContentViewController:navVC];
            _popover = popController;
            [popController presentPopoverFromRect:rect inView:self.webView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else{
            UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"lessonNavigationController"];
            newCalenderEventViewController *view = (newCalenderEventViewController *)navVC.topViewController;
            
            view.delegate = (id)self;
            view.dayDate = _date;
            
            StudentCourseLink *link = [[StudentCourseLink alloc] init];
            link.StudentCourseLinkID = [[jsonDictionary objectForKey:@"linkid"]intValue];
            link.Duration = [[jsonDictionary objectForKey:@"linkduration"]intValue];
            link.Hour = [[jsonDictionary objectForKey:@"linkhour"]intValue];
            link.Mins = [[jsonDictionary objectForKey:@"linkmin"]intValue];
            link.Weekday = [[jsonDictionary objectForKey:@"linkweekday"]intValue];
            
            Course *course = [[Course alloc] init];
            course.courseID = [[jsonDictionary objectForKey:@"linkcourseid"]intValue];
            course.name = [Tools base64Decode:[jsonDictionary objectForKey:@"linkcoursename"]];
            link.course = course;
            
            Student *student = [[Student alloc] init];
            student.studentID = [[jsonDictionary objectForKey:@"linkstudentid"]intValue];
            student.name = [Tools base64Decode:[jsonDictionary objectForKey:@"linkstudentname"]];
            link.student = student;
            
            view.link = link;
            view.isLink = YES;
            UIPopoverController *popController = [[UIPopoverController alloc] initWithContentViewController:navVC];
            _popover = popController;
            [popController presentPopoverFromRect:rect inView:self.webView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Tools hideLoader];
    //[self.splitViewController willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
    //[self.view setNeedsLayout];
    [timer invalidate];
    if(_locked)
        [self lock];
    
    else{
        [self showNavigationBar];
    }
    self.webView.hidden = NO;
    self.statusLbl.hidden = YES;
    //[_webView stringByEvaluatingJavaScriptFromString:@"sendDataToIoS();"];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [_popover dismissPopoverAnimated:YES];
    [_calPopover dismissPopoverAnimated:YES];
    
    if([segue.identifier isEqualToString:@"coursesPopover"])
    {
        
        
        UINavigationController *navVC = segue.destinationViewController;
        newCalenderEventViewController *view = (newCalenderEventViewController *)navVC.topViewController;
        view.isLink = YES;
        
        StudentCourseLink *link = [[StudentCourseLink alloc] init];
        link.tutor = [session tutor];
        view.useDefaults = YES;
        view.link = link;
        view.delegate = (id)self;
        _popover = [(UIStoryboardPopoverSegue *) segue popoverController];
    }
    
    if([segue.identifier isEqualToString:@"editLessonSlotsPopover"])
    {
        
    }
    
    if([segue.identifier isEqualToString:@"newCalenderItem"])
    {
        UINavigationController *navVC = segue.destinationViewController;
        newCalenderEventViewController *view = (newCalenderEventViewController *)navVC.topViewController;
        view.delegate = (id)self;
        view.dayDate = _date;
        view.useDefaults = YES; // !!
        //view.accessibilityValue = @"coursesPopover";
        //view.tutor = [session tutor];
        _popover = [(UIStoryboardPopoverSegue *) segue popoverController];
    }
    
}

- (BOOL)splitViewController: (UISplitViewController*)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    //This method is only available in iOS5
    
    return YES;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
}

-(void)setModalSize
{
    [self setNavigationBarSize];
    int longSide = 987;
    int shortSide = 717;
   

    [UIView animateWithDuration:0.0f
                          delay:0.00
                        options:UIViewAnimationOptionCurveEaseOut
     
                     animations:^{
                         if (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
                         {
                             [self.navigationController.view.superview setBounds:CGRectMake(0, 0, shortSide, longSide)];
                         }
                         else{
                             [self.navigationController.view.superview setBounds:CGRectMake(0, 0, longSide, shortSide)];
                         }
                     }
                     completion:^(BOOL finished){
                         [self setNavigationBarSize];
                     }];
    

    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    
    //if([self.accessibilityValue isEqualToString:@"calenderView"]){
    
    [self setModalSize];
    [_popover dismissPopoverAnimated:YES];
    //}
    
    //self.view.superview.bounds = CGRectMake(0, 0, (self.view.frame.size.width - 50), (self.view.frame.size.height - 50));
}

-(void)viewDidDisappear:(BOOL)animated
{
    [Tools hideLoader];
    [_popover dismissPopoverAnimated:YES];
    [_calPopover dismissPopoverAnimated:YES];
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
