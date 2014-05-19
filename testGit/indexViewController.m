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
    TopBorder.frame = CGRectMake(0.0f, 0.0f, _box1View.frame.size.width, 3.0f);
    TopBorder.backgroundColor = [Tools colorFromHexString:@"#4473b4"].CGColor;
    [_studentView.layer addSublayer:TopBorder];
    [Tools addShadowToViewWithView:_studentView];
    
    //course box border
    TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, _box1View.frame.size.width, 3.0f);
    TopBorder.backgroundColor = [Tools colorFromHexString:@"#57AD2C"].CGColor;
    [_courseView.layer addSublayer:TopBorder];
    [Tools addShadowToViewWithView:_courseView];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[_lesson dateTime]];
    NSInteger lessonDateHour = [components hour];
    NSInteger lessonDateMinute = [components minute];
    [_lesson setHour:(int)lessonDateHour];
    [_lesson setMins:(int)lessonDateMinute];
    
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
    _lessonTimeLbl.text = [NSString stringWithFormat:@"%02d:%02d (%02d mins)",
                           [_lesson Hour],
                           [_lesson Mins],
                           [_lesson Duration]
                           ];
    
    _courseNameLbl.text = [[_lesson course] name];
    _studentNameLbl.text = [[_lesson student] name];
    
    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    self.navigationController.navigationBar.tintColor = [UIColor greenColor];
    
    UIBarButtonItem *noteBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Note Sticky.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain  target:self action:@selector(goToNotes)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:noteBtn, nil]];
    
    //timer
    [self updateLabels];
    _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
    
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
    NVDate *lessonDate = [[NVDate alloc] initUsingDate:[_lesson dateTime]];
    NSDate *lessonEnd = lessonDate.date;
    lessonEnd = [lessonDate.date dateByAddingTimeInterval:[_lesson Duration]*60];
    NVDate *nowDate = [[NVDate alloc] initUsingToday];
    
    NSString *dayDesc;
    
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
        
        
        //        if ([nowDate.date compare:lessonDate.date] == NSOrderedDescending &&
        //            [nowDate.date compare:lessonEnd] == NSOrderedAscending) {
        //
        //        }
        //        else if([[nowDate.date laterDate:lessonEnd] isEqualToDate:lessonEnd]){
        //            NSTimeInterval secondsBetween = [lessonDate.date timeIntervalSinceDate:nowDate.date];
        //            NSLog(@"Lesson in: %@", [Tools convertSecondsToTimeStringWithSeconds:secondsBetween]);
        //        }
        
    }
    else{
        dayDesc = [NSString stringWithFormat:@"%li.%li.%li", (long)lessonDate.day, (long)lessonDate.month, (long)lessonDate.year];
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
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Phone call unsuccessful" message:@"You cannot make phone calls from this device!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
    NSLog(@"Students phone number: %@", [[_lesson student] phone]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
