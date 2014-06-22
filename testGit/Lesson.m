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

-(void)save
{
    //NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=tutorsandcoursesbyclient&id=%li", [self clientID]];
    
    
    //self.courses = [jsonReader jsonRequestWithUrl:urlString];
    
    
}

@end
