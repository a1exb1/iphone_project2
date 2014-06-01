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

@interface indexViewController ()
@property (strong, nonatomic) IBOutlet UIView *box1View;
@property (weak, nonatomic) IBOutlet UILabel *lessonTimeLbl;

@property (weak, nonatomic) IBOutlet UIView *courseView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLbl;

@property (weak, nonatomic) IBOutlet UIView *studentView;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLbl;

@property (weak, nonatomic) IBOutlet UIButton *lessonNotesBtn;
@property (weak, nonatomic) IBOutlet UILabel *dayDescLbl;

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation indexViewController

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
    [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:nil andTint:[Tools colorFromHexString:@"#4473b4"] theme:@"light"];
    
    if([Tools isIpad]){
        [Tools addECSlidingDefaultSetupWithViewController:self];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
//    if(_loaded == true){
//        [self.navigationController popViewControllerAnimated:NO];
//    }
//    
//    _loaded = true;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // now box border
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, _box1View.frame.size.width, 3.0f);
    TopBorder.backgroundColor = [Tools colorFromHexString:@"#990f60"].CGColor;
    //orange : e84721
    //#
    [_box1View.layer addSublayer:TopBorder];
    [Tools addShadowToViewWithView:_box1View];
    
    //student box border
    TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, _studentView.frame.size.width, 3.0f);
    TopBorder.backgroundColor = [Tools colorFromHexString:@"#4473b4"].CGColor;
    [_studentView.layer addSublayer:TopBorder];
    [Tools addShadowToViewWithView:_studentView];
    
    //course box border
    TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, _courseView.frame.size.width, 3.0f);
    TopBorder.backgroundColor = [Tools colorFromHexString:@"#57AD2C"].CGColor;
    [_courseView.layer addSublayer:TopBorder];
    [Tools addShadowToViewWithView:_courseView];
    
    _menuBtn = self.navigationItem.leftBarButtonItem;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.splitViewController.delegate = self;
    }
    
//    NSString *dayDesc = @"";
//    NVDate *lessonDate = [[NVDate alloc] initUsingDate:[_lesson dateTime]];
//    NVDate *nowDate = [[NVDate alloc] initUsingToday];
//    
//    if ([[self beginningOfDay:lessonDate.date] isEqualToDate:[self beginningOfDay:nowDate.date]])
//    {
//        dayDesc = @"Today";
//    }
//    else{
//        dayDesc = [NSString stringWithFormat:@"%li.%li.%li", (long)lessonDate.day, (long)lessonDate.month, (long)lessonDate.year];
//    }
    
    //_dayDescLbl.text = dayDesc;
    

    
    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    self.navigationController.navigationBar.tintColor = [UIColor greenColor];
    
    UIBarButtonItem *noteBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1012-sticky-note-toolbar@2x-selected.png"]  style:UIBarButtonItemStylePlain  target:self action:@selector(goToNotes)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:noteBtn, nil]];
    
    //timer
    [self updateLabels];
    _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
    
    [_attendenceControl addTarget:self
                           action:@selector(changeAttendence:)
                 forControlEvents:UIControlEventValueChanged];
    
}

-(void)changeAttendence:(UISegmentedControl *)segment
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=lessonstatus&id=%li&status=%li&ts=%f", [_lesson LessonID], (long)[segment selectedSegmentIndex], [[NSDate date] timeIntervalSince1970]];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    _resultArray = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
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
    _courseNameLbl.text = [[_lesson course] name];
    _studentNameLbl.text = [[_lesson student] name];
    _attendenceControl.selectedSegmentIndex = [_lesson status];
    [self updateLabels];
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
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
    
    _lessonTimeLbl.text = [NSString stringWithFormat:@"%02d:%02d - %@ (%02d mins)",
                           [_lesson Hour],
                           [_lesson Mins],
                           [Tools convertDateToTimeStringWithDate:lessonEnd],
                           [_lesson Duration]
                           ];
    
    if ([[self beginningOfDay:lessonDate.date] isEqualToDate:[self beginningOfDay:nowDate.date]])
    {
        dayDesc = @"Today";
        _dayDescLbl.text = dayDesc;
        
        if (
            ([nowDate.date timeIntervalSinceReferenceDate] > [lessonDate.date timeIntervalSinceReferenceDate]) &&
            ([nowDate.date timeIntervalSinceReferenceDate] < [lessonEnd timeIntervalSinceReferenceDate])
            ) {
            NSTimeInterval secondsBetween = [lessonEnd timeIntervalSinceDate:nowDate.date];
            dayDesc = [NSString stringWithFormat:@"Now (%@ left)", [Tools convertSecondsToTimeStringWithSecondsWithAlternativeStyle:secondsBetween]];
            _dayDescLbl.text = dayDesc;
        }
        
        else if ([nowDate.date timeIntervalSinceReferenceDate] > [lessonDate.date timeIntervalSinceReferenceDate]) {
            dayDesc = @"Earlier";
            _dayDescLbl.text = dayDesc;
        }
        
        else if ([nowDate.date timeIntervalSinceReferenceDate] < [lessonEnd timeIntervalSinceReferenceDate]) {
            NSTimeInterval secondsBetween = [lessonDate.date timeIntervalSinceDate:nowDate.date];
            dayDesc = [NSString stringWithFormat:@"Lesson in: %@", [Tools convertSecondsToTimeStringWithSecondsWithAlternativeStyle:secondsBetween]];
            _dayDescLbl.text = dayDesc;
        }
        
        
    }
    else{
        dayDesc = [NSString stringWithFormat:@"%02ld.%02ld.%li", (long)lessonDate.day, (long)lessonDate.month, (long)lessonDate.year];
        _dayDescLbl.text = dayDesc;
    }

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


- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Agenda", @"Agenda");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
    
    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(showMainMenu)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:_menuBtn, barButtonItem, nil]];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
    
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

@end
