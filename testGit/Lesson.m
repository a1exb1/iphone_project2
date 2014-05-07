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

@end
