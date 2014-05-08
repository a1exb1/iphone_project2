//
//  ViewController.m
//  DSLCalendarViewExample
//
//  Created by Pete Callaway on 12/08/2012.
//  Copyright (c) 2012 Pete Callaway. All rights reserved.
//

#import "DSLCalendarView.h"
#import "SelectDateViewController.h"
#import "Tools.h"

@interface SelectDateViewController ()


@property (nonatomic, weak) IBOutlet DSLCalendarView *calendarView;

@end


@implementation SelectDateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.calendarView.delegate = self;
    
    [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:[Tools defaultNavigationBarColour] andTint:[Tools colorFromHexString:@"#e5534b"] theme:@"light"];
    self.navigationController.navigationBar.translucent = NO;
    [self.tabBarController.tabBar setTintColor:[Tools colorFromHexString:@"#e5534b"]];
    // red e5534b
    //blue 4473b4
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = item;
    
    NSDate *today = _previousDate;
    NSDate *end = [today dateByAddingTimeInterval:7 * 24 * 3600];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *dateCompStart = [calendar components:NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:today];
    NSDateComponents *dateCompEnd = [calendar components:NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:end];
    
    DSLCalendarRange *range = [[DSLCalendarRange alloc] initWithStartDay:dateCompStart endDay:dateCompStart];
    
    [self.calendarView setSelectedRange:range];
}

-(void)back {
    [UIView animateWithDuration:0.45
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:NO];
    
    //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];

}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - DSLCalendarViewDelegate methods

- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil) {
        //N  ;
        //NSLog(@"%02d/%02d/%i", (int)range.startDay.day, (int)range.startDay.month, (int)range.startDay.year);
        NSString *str = [[NSString alloc] initWithFormat: @"%02d/%02d/%i", (int)range.startDay.day, (int)range.startDay.month, (int)range.startDay.year];
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        NSDate* lessonDate = [formatter dateFromString:str];
                
        [self.selectDateDelegate sendDateToAgendaWithDate: lessonDate];
        
        [self back];
        
    }
    else {
        NSLog( @"No selection" );
    }
}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range {
    if (YES) { // Only select a single day
        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
    }
    else if (NO) { // Don't allow selections before today
        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
        NSDateComponents *startDate = range.startDay;
        NSDateComponents *endDate = range.endDay;
        
        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
            return nil;
        }
        else {
            if ([self day:startDate isBeforeDay:today]) {
                startDate = [today copy];
            }
            if ([self day:endDate isBeforeDay:today]) {
                endDate = [today copy];
            }
            
            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
        }
    }
    
    return range;
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration {
    NSLog(@"Will show %@ in %.3f seconds", month, duration);
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
    NSLog(@"Now showing %@", month);
}

- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

@end
