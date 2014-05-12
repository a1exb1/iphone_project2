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
    
    _lessonTimeLbl.text = [NSString stringWithFormat:@"%02d:%02d",
                           [_lesson Hour],
                           [_lesson Mins]
                           ];
    
    _courseNameLbl.text = [[_lesson course] name];
    _studentNameLbl.text = [[_lesson student] name];
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithTitle:@"Re-schedule" style:UIBarButtonItemStyleBordered target:self action:@selector(editLesson)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:editBtn, nil]];
}

-(void)editLesson{
    
}


-(IBAction)lessonNotes:(id)sender
{
        NotesViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"allNotesView"];
        view.lesson = _lesson;
    
        [self.navigationController pushViewController:view animated:YES];
}

-(IBAction)call:(id)sender
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:000-000-0000"]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Phone call unsuccessful" message:@"You cannot make phone calls from this device!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
