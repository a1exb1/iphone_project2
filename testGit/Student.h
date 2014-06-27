//
//  Student.h
//  testGit
//
//  Created by Thomas Kjær Christensen on 28/04/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "User.h"


@interface Student : User

@property long studentID;
@property NSArray *studentNotes;
//@property StudentCourseLink *studentCourseLink;

@property double outstanding;

@end
