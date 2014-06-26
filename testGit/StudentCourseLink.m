//
//  StudentCourseLink.m
//  testGit
//
//  Created by Alex Bechmann on 26/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "StudentCourseLink.h"

@implementation StudentCourseLink

- (id)init {
    
    self = [super init];
    
    if (self) {
        self.Weekday = 1;
        self.Hour = 10;
        self.Mins = 00;
        self.Duration = 30;
        
        // name = jeff;
        
    }
    
    return self;
    
}

-(void) load{
    
}

-(void) loadByID: (long)linkID{
    
}

-(void) save{
    
}

-(void) deleteLink{
    
}

-(NSArray *)saveReturn
{
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=studentcourselink&id=%li&hour=%i&mins=%i&studentid=%li&courseid=%li&weekday=%i&duration=%i&tutorid=%li", [self StudentCourseLinkID], _Hour, _Mins,[[self student] studentID],[[self course]courseID], _Weekday,_Duration,[[self tutor] tutorID]];
    return [jsonReader jsonRequestWithUrl:urlString];
}

-(NSArray *)deleteReturn
{
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=studentcourselink&id=%li&delete=y", [self StudentCourseLinkID]];
    return [jsonReader jsonRequestWithUrl:urlString];
}

@end
