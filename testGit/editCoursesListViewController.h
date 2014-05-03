//
//  editCoursesListViewController.h
//  testGit
//
//  Created by Alex Bechmann on 03/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "Tutor.h"

@interface editCoursesListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSArray *courses;
@property NSMutableData *data;

@property Tutor *tutor;
@property Course *courseSender;

@end
