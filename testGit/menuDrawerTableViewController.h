//
//  menuDrawerTableViewController.h
//  PlanIt!
//
//  Created by Alex Bechmann on 27/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"

#import "Tools.h"
#import "calenderViewController.h"

@interface menuDrawerTableViewController : UITableViewController

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;

@property NSMutableArray *cellsArray;
@property NSArray *sectionsArray;

@end
