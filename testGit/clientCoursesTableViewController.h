//
//  clientCoursesTableViewController.h
//  PlanIt!
//
//  Created by Alex Bechmann on 20/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"
#import "Course.h"
#import "saveCourseViewController.h"
#import "customTableViewCell.h"

@interface clientCoursesTableViewController : UITableViewController

@property (nonatomic, strong) UIBarButtonItem *navigationPaneBarButtonItem;
@property bool loaded;
@property bool pushed;
@property NSIndexPath *indexPath;
@property float scrollPosition;
@end
