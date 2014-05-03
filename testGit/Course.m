//
//  Course.m
//  testGit
//
//  Created by Thomas Kjær Christensen on 01/05/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "Course.h"

@implementation Course

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.courseID = 0;
        self.name = [NSString stringWithFormat:@""];
        
        // name = jeff;
        
    }
    
    return self;
    
}

@end
