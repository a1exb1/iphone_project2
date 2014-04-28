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


@end
