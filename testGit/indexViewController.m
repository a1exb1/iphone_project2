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

@interface indexViewController ()
@property (strong, nonatomic) IBOutlet UIView *box1View;

@property (weak, nonatomic) IBOutlet UILabel *lessonTimeLbl;

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

-(void)viewDidAppear:(BOOL)animated
{
    [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:nil andTint:[Tools colorFromHexString:@"#4473b4"] theme:@"light"];
}

- (void)viewDidLoad
{
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, _box1View.frame.size.width, 3.0f);
    TopBorder.backgroundColor = [Tools colorFromHexString:@"#4473b4"].CGColor;
    [_box1View.layer addSublayer:TopBorder];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
//    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    NSLog(@"%@",[DateFormatter stringFromDate:[NSDate date]]);
//    
//    NSDate* testDate = [DateFormatter dateFromString:@"1995-04-21 03:31:30"];
//    NSLog(@"%@", testDate);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[_studentCourseLink dateTime]];
    NSInteger lessonDateHour = [components hour];
    NSInteger lessonDateMinute = [components minute];
    [_studentCourseLink setHour:(int)lessonDateHour];
    [_studentCourseLink setMins:(int)lessonDateMinute];
    
    _lessonTimeLbl.text = [NSString stringWithFormat:@"%02d:%02d",
                           [_studentCourseLink Hour],
                           [_studentCourseLink Mins]
                           ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
