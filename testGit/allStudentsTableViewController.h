//
//  allStudentsTableViewController.h
//  PlanIt!
//
//  Created by Alex Bechmann on 22/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customTableViewCell.h"
#import "Session.h"
#import "Tools.h"
#import "editStudentViewController.h"
#import "Student.h"

@protocol lessonPopoverStudentDelegate <NSObject>
-(void)sendBackStudent:(Student*) student;
@end

@interface allStudentsTableViewController : UITableViewController

@property bool loaded;
@property bool pushed;
@property (nonatomic, strong) UIBarButtonItem *navigationPaneBarButtonItem;
@property float scrollPosition;
@property NSIndexPath *indexPath;

@property id<lessonPopoverStudentDelegate> delegate;

@end
