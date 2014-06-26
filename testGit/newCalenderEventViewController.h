//
//  newCalenderEventViewController.h
//  PlanIt!
//
//  Created by Alex Bechmann on 23/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"
#import "Session.h"
#import "clientCoursesTableViewController.h"
#import "allStudentsTableViewController.h"
//#import "editCoursesTableViewController.h"
#import "DatePickerViewController.h"
#import "PickerViewController.h"
#import "StudentCourseLink.h"
#import "lessonSlotPickerViewController.h"

@protocol calDelegate <NSObject>
-(void)reload;
@end

@interface newCalenderEventViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property Lesson *lesson;
@property StudentCourseLink *link;
@property id<calDelegate> delegate;
@property NSDate *minDate;
@property NSDate *dayDate;
@property bool useDefaults;

@property bool isLink;
@end
