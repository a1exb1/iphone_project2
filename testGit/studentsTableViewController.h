//
//  studentsTableViewController.h
//  PlanIt!
//
//  Created by Alex Bechmann on 04/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentCourseLink.h"
#import "Course.h"
#import "Tutor.h"
#import "Tools.h"

@interface studentsTableViewController : UITableViewController

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

@end
