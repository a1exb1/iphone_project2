//
//  newCalenderEventViewController.h
//  PlanIt!
//
//  Created by Alex Bechmann on 23/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"

@interface newCalenderEventViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property Lesson *lesson;

@end
