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
    
    //UISplitViewController* spv = self.splitViewController;
    //spv.delegate=self;
    //self.hiddenMaster= hide;
    //[self.splitViewController willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
    //[spv.view setNeedsLayout];
}


- (void)setNavigationPaneBarButtonItem:(UIBarButtonItem *)navigationPaneBarButtonItem
{
    NSLog(@"set navigation pane in calender view");
    if (navigationPaneBarButtonItem != _navigationPaneBarButtonItem) {
        if (navigationPaneBarButtonItem)
            //[self.toolbar setItems:[NSArray arrayWithObject:navigationPaneBarButtonItem] animated:NO];
            [self.navigationItem setLeftBarButtonItem:navigationPaneBarButtonItem animated:NO];
        else
            //[self.toolbar setItems:nil animated:NO];
            [self.navigationItem setLeftBarButtonItem:nil animated:NO];
        
        //[self.navigationController.navigationItem setLeftBarButtonItem:navigationPaneBarButtonItem animated:NO];
        _navigationPaneBarButtonItem = navigationPaneBarButtonItem;
        
        [self showNavigationBar];
        
        NSLog(@"title: %@", _navigationPaneBarButtonItem.title);
    }
}

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
    [self.navigationItem setHidesBackButton:YES];
    
    if([self.accessibilityValue isEqualToString:@"calenderView"]){
        _calenderUIButton.action = @selector(selectDate:);
        _calenderUIButton.target = self;
        
        self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:_plusUIButton, _calenderUIButton, nil];
        
        _date = [[NSDate alloc] init];
        [self sendDateToAgendaWithDate:_date];
    }
    else{
        [self loadUrl];
    }
    
    //[self.pc dismissPopoverAnimated:YES];
    
    
    
}

-(void)selectDate:(UIBarButtonItem *)btn;
{
    UINavigationController *controller = [[UINavigationController alloc] init];
    
    SelectDateViewController* viewController2 = [[SelectDateViewController alloc] initWithNibName:@"SelectDateViewController" bundle:nil];
    viewController2.previousDate = _date;
    viewController2.selectDateDelegate = (id)self;
    self.calPopover = [[UIPopoverController alloc] initWithContentViewController:controller];
    
    [controller pushViewController:viewController2 animated:NO];
    [controller.navigationItem setHidesBackButton:YES];
    //self.calPopover = [[UIPopoverController alloc] initWithContentViewController:viewController2];
    
    _calPopover.popoverContentSize = CGSizeMake(320,568);
    
    [_calPopover presentPopoverFromBarButtonItem:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)sendDateToAgendaWithDate:(NSDate *) Date
{
    _date = Date;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"GB"]];
    
    NSDateComponents* comps = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:Date];
    
    [comps setWeekday:2]; // 2: monday
    _firstDateOfWeek = [calendar dateFromComponents:comps];
    
    [_calPopover dismissPopoverAnimated:YES];
    [self loadUrl];
    
}

//-(void)showNavigationBar
//{
//    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:refreshBtn, nil]];
//}

//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    [_webView stringByEvaluatingJavaScriptFromString:@"adjustContainer();"];
//
//}

-(void)changed
{
    
}

-(void)showNavigationBar
{
    [self.navigationItem setHidesBackButton:NO];
    UIBarButtonItem *addLessonsBtn = nil;
    if ([self.accessibilityValue isEqualToString:@"lessonSlots"]) {
        addLessonsBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add to calender" style:UIBarButtonItemStylePlain target:self action:@selector(addLessons)];
    }
    
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:_navigationPaneBarButtonItem, refreshBtn, _lockBtn, addLessonsBtn, nil]];
}

-(void)addLessons
{
    AddLessonsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"addLessonsView"];
    
    view.shouldClear = NO;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)hideNavigationBar
{
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:nil, nil]];
}

-(void)lock
{
    [_webView stringByEvaluatingJavaScriptFromString:@"lockScreen();"];
    _lockBtn = [[UIBarButtonItem alloc] initWithImage:[self.lockedUIButton image] style:UIBarButtonItemStylePlain target:self action:@selector(unlock)];
    [self showNavigationBar];
}

-(void)unlock
{
    [_webView stringByEvaluatingJavaScriptFromString:@"unlockScreen();"];
    _lockBtn = [[UIBarButtonItem alloc] initWithTitle:@"Lock" style:UIBarButtonItemStylePlain target:self action:@selector(lock)];
    _lockBtn = [[UIBarButtonItem alloc] initWithImage:[self.unlockedUIButton image] style:UIBarButtonItemStylePlain target:self action:@selector(lock)];
    [self showNavigationBar];
}

-(void)loadUrl
{
    self.statusLbl.hidden = YES;
    self.webView.hidden = YES;
    
    NVDate *fromDate = [[NVDate alloc] initUsingDate:_firstDateOfWeek];
    NSString *fromDateString = [[NSString alloc] initWithFormat:@"%ld/%ld/%ld", (long)fromDate.day, (long)fromDate.month, (long)fromDate.year];
    
    NVDate *toDate = [[NVDate alloc] initUsingDate:fromDate.date];
    [toDate nextDays:7];
    NSString *toDateString = [[NSString alloc] initWithFormat:@"%ld/%ld/%ld", (long)toDate.day, (long)toDate.month, (long)toDate.year];
    
    [self hideNavigationBar];
    [Tools showLoaderWithView:self.navigationController.view];
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
    [self.webView loadRequest:requestObj];
}


-(void)viewWillAppear:(BOOL)animated
{
    
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
    NSLog(@"Error : %@",error);
    [Tools hideLoaderFromView:self.navigationController.view];
    //_lockBtn = nil;
    [self showNavigationBar];
    self.statusLbl.hidden = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // webView connected
    //timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Tools hideLoaderFromView:self.navigationController.view];
    //[self.splitViewController willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
    //[self.view setNeedsLayout];
    [timer invalidate];
    [self lock];
    self.webView.hidden = NO;
    
}

- (void)viewDidLayoutSubviews {
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0);
    
    _statusLbl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"coursesPopover"])
    {
        UINavigationController *navVC = segue.destinationViewController;
        coursesViewController *view = (coursesViewController *)navVC.topViewController;
        view.accessibilityValue = @"coursesPopover";
        view.tutor = [session tutor];
        _popover = [(UIStoryboardPopoverSegue *) segue popoverController];
    }
}

- (BOOL)splitViewController: (UISplitViewController*)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    //This method is only available in iOS5
    
    return YES;
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
