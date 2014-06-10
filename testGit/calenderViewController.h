//
//  calenderViewController.h
//  PlanIt!
//
//  Created by Alex Bechmann on 28/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"
#import "coursesViewController.h"
#import "SelectDateViewController.h"
#import "AddLessonsViewController.h"
#import "NVDate.h"
#import "DetailViewManager.h"

@interface calenderViewController : UIViewController <UIWebViewDelegate, calenderViewDelegate, UISplitViewControllerDelegate, SubstitutableDetailViewController>

@property UIBarButtonItem *lockBtn;
@property UIPopoverController *popover;
@property UIPopoverController *calPopover;

@property NSDate *date;
@property NSDate *firstDateOfWeek;

@property (nonatomic, strong) UIBarButtonItem *navigationPaneBarButtonItem;

-(void)changed;

@end
