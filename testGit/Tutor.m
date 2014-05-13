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

@end
