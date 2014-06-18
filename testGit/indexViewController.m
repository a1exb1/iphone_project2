//
//  indexViewController.m
//  testGit
//
//  Created by Alex Bechmann on 17/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "indexViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Tools.h"
#import "NotesViewController.h"
#import "Session.h"

@interface indexViewController ()
@property (strong, nonatomic) IBOutlet UIView *box1View;
@property (weak, nonatomic) IBOutlet UILabel *lessonTimeLbl;

@property (weak, nonatomic) IBOutlet UIView *courseView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLbl;

@property (weak, nonatomic) IBOutlet UIView *studentView;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLbl;

@property (weak, nonatomic) IBOutlet UIButton *lessonNotesBtn;
@property (weak, nonatomic) IBOutlet UILabel *dayDescLbl;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *notesBtn;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIImageView *studentImg;
@property (weak, nonatomic) IBOutlet UIView *lessonTimeView;

@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@end

@implementation indexViewController

extern Session *session;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [session setShouldHideMasterInLandscape:NO];
    
    if ([[session client]clientID] == 0) {
        UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"]; //loginView monthCalView
        
        [self presentViewController:view animated:NO completion:nil];
    }
    
    [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:nil andTint:[Tools colorFromHexString:@"#4473b4"] theme:@"light"];
    
    //UIBarButtonItem *notesBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"1012-sticky-note-toolbar-selected.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(goToNotes)];
    
    self.navigationItem.rightBarButtonItem = _notesBtn;
    
    //[self updateLabels];
    _box1View.hidden = YES;
    _courseView.hidden = YES;
    _studentView.hidden = YES;
    
    if(_lesson == NULL){
        _attendenceControl.hidden = YES;
        _statusLbl.hidden = NO;
        [self.statusLbl setCenter: CGPointMake(self.view.center.x, self.statusLbl.center.y)];
    }
    
    if(_lesson == NULL){
        _box1View.hidden = YES;
        _courseView.hidden = YES;
        _studentView.hidden = YES;
        _attendenceControl.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
        
        _mainTableView.hidden = YES;
        _studentImg.hidden = YES;
        _attendenceControl.hidden = YES;
    }
    
    
}



-(void)viewDidAppear:(BOOL)animated
{
     [self updateLabels];
    _box1View.hidden = NO;
    _courseView.hidden = NO;
    _studentView.hidden = NO;
    if (_navigationPaneBarButtonItem)
        [self.navigationItem setLeftBarButtonItem:self.navigationPaneBarButtonItem animated:NO];
    
    if(_lesson == NULL){
        _box1View.hidden = YES;
        _courseView.hidden = YES;
        _studentView.hidden = YES;
        _attendenceControl.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
        
        _statusLbl.hidden = NO;
        [self.statusLbl setCenter: CGPointMake(self.view.center.x, self.statusLbl.center.y)];
        
        _mainTableView.hidden = YES;
        _studentImg.hidden = YES;
        _attendenceControl.hidden = YES;
    }
    
    [self centers];
    
}

- (void)setNavigationPaneBarButtonItem:(UIBarButtonItem *)navigationPaneBarButtonItem
{
    if (navigationPaneBarButtonItem != _navigationPaneBarButtonItem) {
        if (navigationPaneBarButtonItem)
            //[self.toolbar setItems:[NSArray arrayWithObject:navigationPaneBarButtonItem] animated:NO];
            [self.navigationItem setLeftBarButtonItem:navigationPaneBarButtonItem animated:NO];
        else
            //[self.toolbar setItems:nil animated:NO];
            [self.navigationItem setLeftBarButtonItem:nil animated:NO];
        
        //[self.navigationController.navigationItem setLeftBarButtonItem:navigationPaneBarButtonItem animated:NO];
        _navigationPaneBarButtonItem = navigationPaneBarButtonItem;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //self.splitViewController.delegate = self;
    }
    
    //[session setMenuButtonStyle:self.menuBarButtonStyle];
    //_navigationPaneBarButtonItem.image = [self.menuBarButtonStyle image];
    
    self.navigationItem.leftBarButtonItem = nil;
    if([Tools isIpad]){
        [self.navigationItem setHidesBackButton:YES animated:NO];
    }
    
    self.navigationItem.rightBarButtonItem = nil;

    _courseNameLbl.text = [[_lesson course] name];
    _studentNameLbl.text = [[_lesson student] name];
    _attendenceControl.selectedSegmentIndex = [_lesson status];

    
    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    self.navigationController.navigationBar.tintColor = [UIColor greenColor];

    [self.navigationItem setRightBarButtonItem:_notesBtn];
    
    //timer
    //[self updateLabels];
    _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
    
    [_attendenceControl addTarget:self
                           action:@selector(changeAttendence:)
                 forControlEvents:UIControlEventValueChanged];
    
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    //_studentImg.center = self.view.center;
    //_attendenceControl.center = self.view.center;
    //_mainTableView.center = self.view.center;
    
    //STUDENT IMG
    
    CGRect tempStudentImgFrame = _studentImg.frame;
    if([Tools isOrientationLandscape]){
        _studentImg.frame = CGRectMake(_studentImg.frame.origin.x-40, _studentImg.frame.origin.y, _studentImg.frame.size.width, _studentImg.frame.size.width);
    }
    else{
        _studentImg.frame = CGRectMake(_studentImg.frame.origin.x-150, _studentImg.frame.origin.y, _studentImg.frame.size.width, _studentImg.frame.size.width);
    }
    _studentImg.alpha = 0;
    
    // _attendenceControl
    CGRect tempAttendanceControlFrame = _attendenceControl.frame;
    if([Tools isOrientationLandscape]){
        _attendenceControl.frame = CGRectMake(_attendenceControl.frame.origin.x-40, _attendenceControl.frame.origin.y, _attendenceControl.frame.size.width, _studentImg.frame.size.width);
    }
    else{
        _attendenceControl.frame = CGRectMake(_attendenceControl.frame.origin.x-150, _attendenceControl.frame.origin.y, _attendenceControl.frame.size.width, _studentImg.frame.size.width);
    }
    
    _attendenceControl.alpha = 0;
    
    // TABLE
    CGRect tempTableFrame = _mainTableView.frame;
    if([Tools isOrientationLandscape]){
        _mainTableView.frame = CGRectMake(_mainTableView.frame.origin.x-40, _mainTableView.frame.origin.y, _mainTableView.frame.size.width, _mainTableView.frame.size.width);
    }
    else{
        _mainTableView.frame = CGRectMake(_mainTableView.frame.origin.x-150, _mainTableView.frame.origin.y, _mainTableView.frame.size.width, _mainTableView.frame.size.width);
    }
    
    _mainTableView.alpha = 0;
    
    _lessonTimeView.alpha = 0;
    
    [UIView animateWithDuration:0.3
                          delay:0.00
                        options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         _studentImg.frame = tempStudentImgFrame;
                         _studentImg.alpha = 1;
                         _lessonTimeView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [UIView animateWithDuration:0.25
                          delay:0.05
                        options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         _attendenceControl.frame = tempAttendanceControlFrame;
                         _attendenceControl.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         _mainTableView.frame = tempTableFrame;
                         _mainTableView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    
//    _studentImg.frame = tempStudentImgFrame;
//    _studentImg.alpha = 1;
//    [UIView commitAnimations];
    
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self boxes];
    //[_notesPopover dismissPopoverAnimated:YES];
    //_mainTableView.frame.center = self.view.center;
    //_studentImg.hidden = YES;
    //_attendenceControl.hidden = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [self centers];
    [UIView commitAnimations];
    
    
    
}

-(void)centers
{
    //self.lessonTimeView.frame = CGRectMake(self.lessonTimeView.frame.origin.x, self.lessonTimeView.frame.origin.y, self.view.frame.size.width, _lessonTimeView.frame.size.height);
    [self.mainTableView setCenter: CGPointMake(self.view.center.x, self.mainTableView.center.y)];
    [self.studentImg setCenter: CGPointMake(self.view.center.x, self.studentImg.center.y)];
    [self.attendenceControl setCenter: CGPointMake(self.view.center.x, self.attendenceControl.center.y)];
}

-(void)boxes
{
    
    
    for (CALayer *ca in _box1View.layer.sublayers) {
        if ([ca.accessibilityValue isEqualToString: @"border"]) {
            [ca removeFromSuperlayer];
        }
    }
    for (CALayer *ca in _courseView.layer.sublayers) {
        if ([ca.accessibilityValue isEqualToString: @"border"]) {
            [ca removeFromSuperlayer];
        };
    }
    for (CALayer *ca in _studentView.layer.sublayers) {
        if ([ca.accessibilityValue isEqualToString: @"border"]) {
            [ca removeFromSuperlayer];
        }
    }
    
    
    if((int)self.navigationController.view.frame.size.width == 447)
    {
        _box1View.frame = CGRectMake(20.0f, 87.0f, ((int)self.navigationController.view.frame.size.width  - 40), 90);
        _courseView.frame = CGRectMake(20.0f, 190.0f, ((int)self.navigationController.view.frame.size.width  - 40), _courseView.frame.size.height);
        _studentView.frame = CGRectMake(20.0f, 265.0f, ((int)self.navigationController.view.frame.size.width  - 40), _studentView.frame.size.height);
        
        
    }
    
    
    // now box border
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, _box1View.frame.size.width, 3.0f);
    TopBorder.backgroundColor = [Tools colorFromHexString:@"#990f60"].CGColor;
    //orange : e84721
    //#
    //[_box1View.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    TopBorder.accessibilityValue = @"border";
    [_box1View.layer addSublayer:TopBorder];
    //[Tools addShadowToViewWithView:_box1View];
    
    //student box border
    TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, _studentView.frame.size.width, 3.0f);
    TopBorder.backgroundColor = [Tools colorFromHexString:@"#4473b4"].CGColor;
    TopBorder.accessibilityValue = @"border";
    [_studentView.layer addSublayer:TopBorder];
    //[Tools addShadowToViewWithView:_studentView];
    
    //course box border
    TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, _courseView.frame.size.width, 3.0f);
    TopBorder.backgroundColor = [Tools colorFromHexString:@"#57AD2C"].CGColor;
    TopBorder.accessibilityValue = @"border";
    [_courseView.layer addSublayer:TopBorder];
    //[Tools addShadowToViewWithView:_courseView];
    
    

}

-(void)changeAttendence:(UISegmentedControl *)segment
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=lessonstatus&id=%li&status=%li&ts=%f", [_lesson LessonID], (long)[segment selectedSegmentIndex], [[NSDate date] timeIntervalSince1970]];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

//-(IBAction)Notes:(id)sender
//{
//    [self goToNotes];
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    _resultArray = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    
    [self.agendaDelegate reloadData];
    //UINavigationController *navigationController = [self.splitViewController.viewControllers lastObject];
    //splitViewController.delegate = (id)navigationController.topViewController
    
    //gendaViewController *master = (AgendaViewController *)navigationController.topViewController;
    
    //[master jsonRequestGetAgenda];
    
    if ([_resultArray count] == 0) {

    }
    else{

    }

}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

-(void)changed
{
    [self updateLabels];
}

-(void)goToNotes
{
    NotesViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"allNotesView"];
    view.lesson = _lesson;
    [self.navigationController pushViewController:view animated:YES];
}

- (NSDate *)beginningOfDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comp = [calendar components:unitFlags fromDate:date];
    
    return [calendar dateFromComponents:comp];
}

-(void)onTick:(NSTimer *)timer {
    [self updateLabels];
}

-(void)updateLabels{
    _lessonTimeView.hidden = YES;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[_lesson dateTime]];
    NSInteger lessonDateHour = [components hour];
    NSInteger lessonDateMinute = [components minute];
    [_lesson setHour:(int)lessonDateHour];
    [_lesson setMins:(int)lessonDateMinute];
    
    
    NVDate *lessonDate = [[NVDate alloc] initUsingDate:[_lesson dateTime]];
    NSDate *lessonEnd = lessonDate.date;
    lessonEnd = [lessonDate.date dateByAddingTimeInterval:[_lesson Duration]*60];
    NVDate *nowDate = [[NVDate alloc] initUsingToday];
    
    NSString *dayDesc;
    
    _lessonTime = [NSString stringWithFormat:@"%02d:%02d - %@ (%02d mins)",
                           [_lesson Hour],
                           [_lesson Mins],
                           [Tools convertDateToTimeStringWithDate:lessonEnd],
                           [_lesson Duration]
                           ];
    
    if ([[self beginningOfDay:lessonDate.date] isEqualToDate:[self beginningOfDay:nowDate.date]])
    {
        dayDesc = @"Today";
        _lessonStatus = dayDesc;
        
        if (
            ([nowDate.date timeIntervalSinceReferenceDate] > [lessonDate.date timeIntervalSinceReferenceDate]) &&
            ([nowDate.date timeIntervalSinceReferenceDate] < [lessonEnd timeIntervalSinceReferenceDate])
            ) {
            NSTimeInterval secondsBetween = [lessonEnd timeIntervalSinceDate:nowDate.date];
            dayDesc = [NSString stringWithFormat:@"Now (%@ left)", [Tools convertSecondsToTimeStringWithSecondsWithAlternativeStyle:secondsBetween]];
            _lessonStatus = @"Now";
            _lessonTimeView.hidden = NO;
            _lessonTimeLbl.text = dayDesc;
        }
        
        else if ([nowDate.date timeIntervalSinceReferenceDate] > [lessonDate.date timeIntervalSinceReferenceDate]) {
            dayDesc = @"Earlier";
            _lessonStatus = dayDesc;
        }
        
        else if ([nowDate.date timeIntervalSinceReferenceDate] < [lessonEnd timeIntervalSinceReferenceDate]) {
            NSTimeInterval secondsBetween = [lessonDate.date timeIntervalSinceDate:nowDate.date];
            dayDesc = [NSString stringWithFormat:@"Lesson in: %@", [Tools convertSecondsToTimeStringWithSecondsWithAlternativeStyle:secondsBetween]];
            _lessonStatus = dayDesc;
        }
        
        
    }
    else{
        dayDesc = [NSString stringWithFormat:@"%02ld.%02ld.%li", (long)lessonDate.day, (long)lessonDate.month, (long)lessonDate.year];
        _lessonStatus = dayDesc;
    }
    
    [self.mainTableView reloadData];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_timer invalidate];
}

-(void)editLesson{
    
}


-(IBAction)call:(id)sender
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [[_lesson student] phone]]]];        
    } else {
        NSString *title = [[NSString alloc] initWithFormat:@"Phone call to %@ unsuccessful", [[_lesson student] phone]];
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:title message:@"You cannot make phone calls from this device!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
    NSLog(@"Students phone number: %@", [[_lesson student] phone]);
}

//
//- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
//{
//    //barButtonItem.image = [_menuBtn image];
//    //barButtonItem.title = NSLocalizedString(@"Agenda", @"Agenda");
//    //[self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
//    self.masterPopoverController = popoverController;
//
//    //[self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: barButtonItem, nil]];
//}
//
//- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
//{
//    // Called when the view is shown again in the split view, invalidating the button and popover controller.
//    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
//    self.masterPopoverController = nil;
//    
//}
//
//- (BOOL)splitViewController: (UISplitViewController*)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
//{
//    //This method is only available in iOS5
//    
//    return NO;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

        
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];

    if(indexPath.row == 0){
        cell.imageView.image = [UIImage imageNamed:@"769-male-selected.png"];
        cell.textLabel.text = [[_lesson student] name];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    if(indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"728-clock.png"];
        cell.textLabel.text = _lessonStatus;
        cell.detailTextLabel.text = _lessonTime;
        cell.detailTextLabel.font = [UIFont fontWithName:nil size:14];
        
    }
    
    if(indexPath.row == 2){
        cell.imageView.image = [UIImage imageNamed:@"841-music-playlist.png"];
        cell.textLabel.text = [[_lesson course] name];
    }

    if(indexPath.row == 3){
        cell.imageView.image = [UIImage imageNamed:@"1012-sticky-note.png"];
        cell.textLabel.text = @"Notes";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    if(indexPath.row == 4){
        cell.imageView.image = [UIImage imageNamed:@"888-checkmark.png"];
        cell.textLabel.text = @"To-Do";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    if(indexPath.row == 5){
        cell.imageView.image = [UIImage imageNamed:@"384-dollar-currency.png"];
        cell.textLabel.text = @"Owes £23.50";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    //1012-sticky-note
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0){

        
    }
    
    if(indexPath.row == 1){
        [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
    if(indexPath.row == 2){
        [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if(indexPath.row == 3){
        UINavigationController *navigationController = [[UINavigationController alloc] init];
        
        NotesViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"allNotesView"];
        [view setLesson:_lesson];
        //[self.navigationController pushViewController:view animated:YES];
        
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        navigationController.viewControllers = [[NSArray alloc] initWithObjects:view, nil];
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }
    if(indexPath.row == 4){

        
    }
    
    if(indexPath.row == 5){

        
    }
}

-(void)showMainMenu
{
    [self performSegueWithIdentifier:@"unwindToMenuViewController" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"popoverNotes"])
    {
        
        UINavigationController *navVC = segue.destinationViewController;
        
        // Get reference to the destination view controller
        NotesViewController *view = (NotesViewController *)navVC.topViewController;
        _notesPopover = [(UIStoryboardPopoverSegue *) segue popoverController];
        // Pass any objects to the view controller here, like...
        [view setLesson:_lesson];
    }
}

@end
