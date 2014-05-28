//
//  user.m
//  testGit
//
//  Created by Alex Bechmann on 27/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "User.h"

@implementation User

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.phone = @"";
    }
    
    return self;
    
}

@end
