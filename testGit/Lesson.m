//
//  Lesson.m
//  testGit
//
//  Created by Alex Bechmann on 07/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "Lesson.h"

@implementation Lesson


- (id)init {
    
    self = [super init];
    
    if (self) {
        self.Weekday = 1;
        self.Hour = 00;
        self.Mins = 00;
        self.Duration = 30;
        
        // name = jeff;
        
    }
    
    return self;
    
}



-(void)loadNotes
{
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=notesbystudent&id=%li&lessonid=%li", [[self student] studentID], [self LessonID]];
    
    NSArray *arr = [jsonReader jsonRequestWithUrl:urlString];
    NSMutableArray *thisLessonNotes = [[NSMutableArray alloc] init];
    NSMutableArray *otherLessonNotes = [[NSMutableArray alloc] init];
    
    
    for (int c=0; c < [arr count]; c++) {
        if ([[[arr objectAtIndex:c] objectForKey:@"LessonID"] isEqualToString:[NSString stringWithFormat:@"%li", [self LessonID]]]) {
            [thisLessonNotes addObject:[arr objectAtIndex:c]];
        }
        else{
            [otherLessonNotes addObject:[arr objectAtIndex:c]];
        }
    }

    self.Notes = [[NSArray alloc] initWithObjects:thisLessonNotes, otherLessonNotes, nil];
    
}

-(NSArray *)saveReturn
{
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=addupdatelesson&id=%li&lessondatetime=%@&duration=30&tutorid=%li&courseid=%li&studentid=%li&ts=1402752735",_LessonID, [self formatDate:_dateTime withFormat:@"yyyy-MM-dd HH:mm:ss"], [_tutor tutorID], [_course courseID], [_student studentID]];
    NSLog(@"uirl %@", urlString);
    //return [[NSArray alloc] initWithObjects:@"hi", @"hi1", nil];
    return [jsonReader jsonRequestWithUrl:urlString];
}



//- (NSArray *)saveReturn
//{
//    _saveReturn = [[NSArray alloc] init];
//    return _saveReturn;
//}

-(NSString *)formatDate:(NSDate *)Date withFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *stringFromDate = [formatter stringFromDate:Date];
    return stringFromDate;
}

@end
