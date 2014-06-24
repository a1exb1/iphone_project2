//
//  tutor.m
//  testGit
//
//  Created by Alex Bechmann on 27/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "Tutor.h"

@implementation Tutor

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.tutorID = 0;
        self.accountType = 2;
    }
    
    return self;
    
}



-(NSArray *)loadLessonsForDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
    
    int dd = (int)[components day]; //gives you day
    int mm = (int)[components month]; //gives you month
    int yy = (int)[components year]; // gives you year

    NSString *dateString = [[NSString alloc] initWithFormat:@"%02d/%02d/%i", dd, mm, yy ];
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=lessonsbytutoranddate&id=%li&date=%@&ts=%f", [self tutorID], dateString, [[NSDate date] timeIntervalSince1970]];
    
    NSLog(@"%@", urlString);
    return [jsonReader jsonRequestWithUrl:urlString];

}

-(void)loadCourses
{
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=coursesbytutor&id=%li", [self tutorID]];
    _courses = [jsonReader jsonAsyncRequestWithUrl:urlString];
}

-(void)loadCoursesAsyncWithDelegate:(id)loadDelegate;
{
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=coursesbytutor&id=%li", [self tutorID]];
    jsonReader *reader = [[jsonReader alloc] init];
    reader.delegate = loadDelegate;
    [reader jsonAsyncRequestWithDelegateAndUrl:urlString];
}




@end
