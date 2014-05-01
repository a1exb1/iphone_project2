//
//  studentsViewController.h
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "StudentCourseLink.h"
#import "Course.h"
@interface studentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//@property NSString *courseID;
//@property NSString *courseName;

@property NSArray *students;
@property NSMutableData *data;
@property NSString  *studentIDSender;
@property NSArray *uniqueWeekdays;

@property Student *studentSender;
@property Course *course;
@property int sender;

@end
