//
//  coursesViewController.h
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "Tutor.h"
#import "studentsViewController.h"
#import "viewAllStudentsViewController.h"

@interface coursesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSString *tutorID;
@property NSString *tutorName;
@property Tutor *tutor;

@property NSArray *courses;
@property NSMutableData *data;
@property NSString  *courseIDSender;
@property NSString  *courseNameSender;
@property Course *courseSender;

@property (strong, nonatomic) studentsViewController *detailViewController;
@property bool loaded;
@end
