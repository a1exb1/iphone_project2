//
//  editTutorsTableViewController.h
//  PlanIt!
//
//  Created by Alex Bechmann on 10/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "saveTutorViewController.h"
#import "Tools.h"
#import "Session.h"
#import "DetailViewManager.h"

@interface editTutorsTableViewController : UITableViewController <SubstitutableDetailViewController>

@property NSArray *tutors;
@property NSMutableData *data;

//@property Tutor *tutor;
@property Tutor *tutorSender;

@property (nonatomic, strong) UIBarButtonItem *navigationPaneBarButtonItem;
@property bool loaded;
//@property long currentTutorID;

@end
