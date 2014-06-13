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
        //self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects: closeBtn, _plusUIButton, _calenderUIButton, nil];
        
        _date = [[NSDate alloc] init];
        [self sendDateToAgendaWithDate:_date];
    }
    else{
        //self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects: closeBtn, _addLessonSlotBtn, _editSlotsButton, nil];
        [self loadUrl];
    }    
}

-(void)done
{
    [_popover dismissPopoverAnimated:YES];
    [_calPopover dismissPopoverAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [_menuDrawerDelegate deselectTableRow];
    }];
    
    
}

-(void)selectDate:(UIBarButtonItem *)btn;
{
    [_popover dismissPopoverAnimated:YES];
    [_calPopover dismissPopoverAnimated:YES];
    
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


-(void)changed
{
    
}

-(void)previousWeek
{
    NVDate *date = [[NVDate alloc] initUsingDate:_date];
    [date nextDays:-7];
    _date = date.date;
    [self sendDateToAgendaWithDate:_date];
}

-(void)nextWeek
{
    NVDate *date = [[NVDate alloc] initUsingDate:_date];
    [date nextDays:7];
    _date = date.date;
    [self sendDateToAgendaWithDate:_date];
}

-(void)showNavigationBar
{
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 20;
    
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    
    [self.navigationItem setHidesBackButton:NO];
    [self.navigationItem setLeftBarButtonItem:closeBtn];
    
    if ([self.accessibilityValue isEqualToString:@"calenderView"]) {
        //CALENDER
        UIBarButtonItem *addLessonsBtn = nil;
        addLessonsBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add to calender" style:UIBarButtonItemStylePlain target:self action:@selector(addLessons)];
        
        UIBarButtonItem *calButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"851-calendar-toolbar-selected.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(selectDate:)];
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"765-arrow-left-toolbar-selected.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(previousWeek)];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"766-arrow-right-toolbar-selected.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(nextWeek)];
        
        self.toolbarItems = [NSArray arrayWithObjects: refreshBtn, fixedSpace, _lockBtn, fixedSpace, fixedSpace, leftButton, fixedSpace,  rightButton, fixedSpace, fixedSpace, calButton, nil];
        
        
    }
    else{
        [self.navigationItem setRightBarButtonItem:_addLessonSlotBtn];
        self.toolbarItems = [NSArray arrayWithObjects:refreshBtn,fixedSpace,  _lockBtn, nil];
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
    //[self.navigationItem setHidesBackButton:YES];
    //[self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:nil, nil]];
    self.toolbarItems = nil;
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
    [Tools showLoaderWithView:self.view];
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
    NSLog(@"Error : %@",error);
    [Tools hideLoaderFromView:self.view];
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
    [Tools hideLoaderFromView:self.view];
    //[self.splitViewController willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
    //[self.view setNeedsLayout];
    [timer invalidate];
    [self lock];
    self.webView.hidden = NO;
    
}

- (void)viewDidLayoutSubviews {
    [self.navigationController setToolbarHidden:NO];
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
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
    
    
    //self.view.superview.bounds = CGRectMake(0, 0, (self.view.frame.size.width - 50), (self.view.frame.size.height - 50));
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
