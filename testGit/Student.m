//
//  Student.m
//  testGit
//
//  Created by Thomas Kjær Christensen on 28/04/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "Student.h"

@implementation Student

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.studentID = 0;
        self.name = [NSString stringWithFormat:@"Noname"];
       
        // name = jeff;
        
    }
    
    return self;
    
}

@end
