//
//  addLessonsTableViewController.h
//  PlanIt!
//
//  Created by Alex Bechmann on 04/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "AddLessonsViewController.h"

@interface addLessonsTableViewController : UITableViewController

@property NSMutableArray *cellsArray;
@property NSArray *sectionsArray;
@property (strong, nonatomic) DetailViewController *detailViewController;

@end
