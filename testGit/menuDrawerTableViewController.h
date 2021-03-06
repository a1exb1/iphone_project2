//
//  menuDrawerTableViewController.h
//  PlanIt!
//
//  Created by Alex Bechmann on 27/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "calenderViewController.h"
#import "tutors2ViewController.h"
#import "Tools.h"
#import "studentsViewController.h"
#import "Course.h"
#import "coursesViewController.h"
#import "addLessonsTableViewController.h"
#import "DetailViewManager.h"
#import "editTutorsTableViewController.h"
#import "editCoursesTableViewController.h"
#import "loginViewController.h"
#import "clientCoursesTableViewController.h"

@interface menuDrawerTableViewController : UITableViewController

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;

@property NSMutableArray *cellsArray;
@property NSArray *sectionsArray;
@property Course *courseSender;


@property (strong, nonatomic) DetailViewController *detailViewController;

@property NSIndexPath *indexPath;

@end
