//
//  CalenderViewController.m
//  testGit
//
//  Created by Thomas Kjær Christensen on 07/05/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "CalenderViewController.h"

@interface CalenderViewController ()

@end

@implementation CalenderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:[Tools defaultNavigationBarColour] andTint:[Tools colorFromHexString:@"#e5534b"] theme:@"light"];
    self.navigationController.navigationBar.translucent = NO;
    [self.tabBarController.tabBar setTintColor:[Tools colorFromHexString:@"#e5534b"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
//
//// 1. Instantiate a CKCalendarViewController
//    CKCalendarViewController *calendar = [CKCalendarViewController new];
//    
//    // 2. Optionally, set up the datasource and delegates
//    [calendar setDelegate:self];
//    [calendar setDataSource:self];
//    
//    // 3. Present the calendar
//    [self presentViewController:calendar animated:YES completion:nil];
//
    
    // 1. Instantiate a CKCalendarView
    CKCalendarView *calendar = [CKCalendarView new];
    
    // 2. Optionally, set up the datasource and delegates
    [calendar setDelegate:self];
    [calendar setDataSource:self];
    // adding another event
  
    
        
        // 3. Present the calendar
    [[self view] addSubview:calendar];
    
    
    // Do any additional setup after loading the view.
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


- (void)calendarView:(CKCalendarView *)calendarView didSelectDate:(NSDate *)date{
    NSLog(@"hi");
}
@end
