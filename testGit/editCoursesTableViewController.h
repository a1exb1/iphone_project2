//
//  editCoursesTableViewController.h
//  PlanIt!
//
//  Created by Alex Bechmann on 11/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "Tutor.h"
#import "editCoursesListViewController.h"
#import "saveCourseViewController.h"
#import "Tools.h"
#import "DetailViewController.h"
#import "customTableViewCell.h"

@interface editCoursesTableViewController : UITableViewController <SubstitutableDetailViewController>


@property NSArray *courses;
@property NSMutableData *data;

@property Tutor *tutor;
@property Course *courseSender;

@property (nonatomic, strong) UIBarButtonItem *navigationPaneBarButtonItem;
@property bool loaded;

@end
