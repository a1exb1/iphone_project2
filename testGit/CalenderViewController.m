//
//  ViewController.m
//  DSLCalendarViewExample
//
//  Created by Pete Callaway on 12/08/2012.
//  Copyright (c) 2012 Pete Callaway. All rights reserved.
//

#import "DSLCalendarView.h"
#import "CalenderViewController.h"
#import "SelectDateViewController.h"

@interface CalenderViewController () <DSLCalendarViewDelegate>

@property (nonatomic, weak) IBOutlet DSLCalendarView *calendarView;

@end

@implementation CalenderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
}

-(IBAction)cald:(id)sender
{
    SelectDateViewController *viewController = [[SelectDateViewController alloc] initWithNibName:@"SelectDateViewController" bundle:nil];
    //    window.rootViewController = viewController;
    //    [window makeKeyAndVisible];
//    indexViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"dayView"];
//    view.lesson = _lessonSender;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
//    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//    window.rootViewController = viewController;
//    [window makeKeyAndVisible];
    
    //    NSDateComponents *newMonth = self.calendarView.visibleMonth;
    //    newMonth.month--;
    //
    //    NSLog(@"current month%i", self.calendarView.visibleMonth.month);
    //    //
    //    [self.calendarView setVisibleMonth:newMonth animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}
//
//
//#pragma mark - DSLCalendarViewDelegate methods
//
//- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
//    if (range != nil) {
//        NSLog( @"Selected %ld/%ld - %ld/%ld", (long)range.startDay.day, (long)range.startDay.month, (long)range.endDay.day, (long)range.endDay.month);
//    }
//    else {
//        NSLog( @"No selection" );
//    }
//}
//
//- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range {
//    if (YES) { // Only select a single day
//        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
//    }
//    else if (NO) { // Don't allow selections before today
//        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
//        
//        NSDateComponents *startDate = range.startDay;
//        NSDateComponents *endDate = range.endDay;
//        
//        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
//            return nil;
//        }
//        else {
//            if ([self day:startDate isBeforeDay:today]) {
//                startDate = [today copy];
//            }
//            if ([self day:endDate isBeforeDay:today]) {
//                endDate = [today copy];
//            }
//            
//            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
//        }
//    }
//    
//    return range;
//}
//
//- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration {
//    NSLog(@"Will show %@ in %.3f seconds", month, duration);
//}
//
//- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
//    NSLog(@"Now showing %@", month);
//}
//
//- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
//    return ([day1.date compare:day2.date] == NSOrderedAscending);
//}

@end