//
//  studentsViewController.h
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentCourseLink.h"
#import "Course.h"
#import "Tutor.h"

#import "editStudentAndSlotViewController.h"
#import "viewAllStudentsViewController.h"

@interface studentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//@property NSString *courseID;
//@property NSString *courseName;

@property NSArray *students;
@property NSMutableData *data;
@property NSString  *studentIDSender;
@property NSArray *uniqueWeekdays;

@property StudentCourseLink *studentCourseLinkSender;
@property Course *course;
@property Tutor *tutor;
@property int sender;

@property bool editing;

-(void)loadData;

@property (strong, nonatomic) editStudentAndSlotViewController *detailViewController;

@end
