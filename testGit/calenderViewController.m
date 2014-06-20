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


-(void)viewDidAppear:(BOOL)animated
{    
    if (_navigationPaneBarButtonItem)
        [self.navigationItem setLeftBarButtonItem:self.navigationPaneBarButtonItem animated:NO];
    
//    UISplitViewController* spv = self.splitViewController;
//    //spv.delegate=self;
//    [spv willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
//    [spv.view setNeedsLayout];
    [self setModalSize];
}


//- (void)setNavigationPaneBarButtonItem:(UIBarButtonItem *)navigationPaneBarButtonItem
//{
//    NSLog(@"set navigation pane in calender view");
//    if (navigationPaneBarButtonItem != _navigationPaneBarButtonItem) {
//        if (navigationPaneBarButtonItem)
//            //[self.toolbar setItems:[NSArray arrayWithObject:navigationPaneBarButtonItem] animated:NO];
//            [self.navigationItem setLeftBarButtonItem:navigationPaneBarButtonItem animated:NO];
//        else
//            //[self.toolbar setItems:nil animated:NO];
//            [self.navigationItem setLeftBarButtonItem:nil animated:NO];
//        
//        //[self.navigationController.navigationItem setLeftBarButtonItem:navigationPaneBarButtonItem animated:NO];
//        _navigationPaneBarButtonItem = navigationPaneBarButtonItem;
//        
//        [self showNavigationBar];
//        
//        NSLog(@"title: %@", _navigationPaneBarButtonItem.title);
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView.delegate = self;
    
    if([self.accessibilityValue isEqualToString:@"calenderView"]){
        self.title = @"Calender";
        
        [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: nil andBackground: nil andTint:[Tools colorFromHexString:@"#b44444"] theme:@"light"];
    }
    else{
        self.title = @"Lesson slots";
        
        [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: nil andBackground:[Tools defaultNavigationBarColour] andTint:[Tools colorFromHexString:@"#57AD2C"] theme:@"light"];
    }

    [session setCalController:self];
    [self showNavigationBar];
    //[self.navigationItem setHidesBackButton:YES];
    
    if([self.accessibilityValue isEqualToString:@"calenderView"]){
        //_calenderUIButton.action = @selector(selectDate:);
        //_calenderUIButton.target = self;
        //self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects: closeBtn, _plusUIButton, _calenderUIButton, nil];
        
        if(_date == NULL){
            _date = [[NSDate alloc] init];
        }
        
        [self sendDateToAgendaWithDate:_date];
    }
    else{
        //self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects: closeBtn, _addLessonSlotBtn, _editSlotsButton, nil];
        [self loadUrl];
    }
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"765-arrow-left-toolbar-selected.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    [self setModalSize];
    if([self.accessibilityValue isEqualToString:@"calenderView"]){
        [self setNavigationBarSize];
    }
    
    int c = 0;
    int containerWidth = (self.view.frame.size.width /100) * 91;
    int width = containerWidth / 7;
    int leftPadding =self.view.frame.size.width - containerWidth;
    
    for(UIView *view in self.navigationController.navigationBar.subviews){
        if([view.accessibilityValue isEqualToString:@"dayTitle"]){
            int l = leftPadding + (c * width);
            
            NSLog(@"%f, %d, %d",self.view.frame.size.width, containerWidth, width);
            if(c==0) {
                //view.backgroundColor = [UIColor redColor];
            }
            view.frame = CGRectMake(l, view.frame.origin.y, width, view.frame.size.height);

            c++;
        }
    }
}

-(void)done
{
    [_popover dismissPopoverAnimated:YES];
    [_calPopover dismissPopoverAnimated:YES];
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        [_menuDrawerDelegate deselectTableRow];
//    }];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.monthCalenderDelegate sendDateToAgendaWithDate:NULL];
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
        
        self.toolbarItems = [NSArray arrayWithObjects: refreshBtn, fixedSpace, _lockBtn, flex, segmentButton, flex, leftButton, fixedSpace,  rightButton, nil];
        
        
    }
    else{
        [self.navigationItem setRightBarButtonItem:_addLessonSlotBtn];
        self.toolbarItems = [NSArray arrayWithObjects:refreshBtn,fixedSpace,  _lockBtn, nil];
    }
    
    if([self.accessibilityValue isEqualToString:@"calenderView"]){
        [self setNavigationBarSize];
    }
    
}

-(void)changeCalType
{
    monthCalenderViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"monthCal"];
    view.dayDate = _date;
    view.monthCalenderDelegate = self.monthCalenderDelegate;
    [view drawSquaresWithDirection:3 andOldContainer:nil];
    self.navigationController.viewControllers = [[NSArray alloc] initWithObjects:view, nil];
}

-(void)setNavigationBarSize
{
    self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width,75);
    
    CGFloat verticalOffset = -27; //31 is same as default
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.rightBarButtonItem setBackgroundVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem.leftBarButtonItem setBackgroundVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    
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
    [self showNavigationBar];
}

-(void)unlock
{
    [_webView stringByEvaluatingJavaScriptFromString:@"unlockScreen();"];
    _lockBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"745-unlocked-toolbar.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(lock)];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Tools hideLoader];
    //[self.splitViewController willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
    //[self.view setNeedsLayout];
    [timer invalidate];
    [self lock];
    self.webView.hidden = NO;
    self.statusLbl.hidden = YES;
    
}

- (void)viewDidLayoutSubviews {
    [self.navigationController setToolbarHidden:NO];
    if([self.accessibilityValue isEqualToString:@"calenderView"]){
        self.webView.frame = CGRectMake(0, -23, self.view.frame.size.width, self.view.frame.size.height);
    }
    else{
        self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    
    _statusLbl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
        coursesViewController *view = (coursesViewController *)navVC.topViewController;
        view.accessibilityValue = @"coursesPopover";
        view.tutor = [session tutor];
        _popover = [(UIStoryboardPopoverSegue *) segue popoverController];
    }
    
    if([segue.identifier isEqualToString:@"editLessonSlotsPopover"])
    {
        
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
    int longSide = 987;
    int shortSide = 717;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        [self.navigationController.view.superview setBounds:CGRectMake(0, 0, shortSide, longSide)];
    }
    else{
        [self.navigationController.view.superview setBounds:CGRectMake(0, 0, longSide, shortSide)];
    }
    
    [UIView commitAnimations];
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [self setModalSize];
    if([self.accessibilityValue isEqualToString:@"calenderView"]){
        [self setNavigationBarSize];
    }
    
    //self.view.superview.bounds = CGRectMake(0, 0, (self.view.frame.size.width - 50), (self.view.frame.size.height - 50));
}

-(void)viewDidDisappear:(BOOL)animated
{
    [Tools hideLoader];
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
