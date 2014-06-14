//
//  Lesson.h
//  testGit
//
//  Created by Alex Bechmann on 07/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"
#import "Course.h"
#import "Tutor.h"
#import "jsonReader.h"

@interface Lesson : NSObject

@property long LessonID;
//@property long StudentID;
//@property long CourseID;
@property int Duration;
@property int Weekday;
@property int Hour;
@property int Mins;
@property NSDate *dateTime;
@property Course *course;
@property Student *student;
@property Tutor *tutor;

@property int status;

@property NSArray *Notes;

-(void)loadNotes;

@end
