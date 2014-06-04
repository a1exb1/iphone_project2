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

#import "AddLessonsViewController.h"

@interface calenderViewController : UIViewController <UIWebViewDelegate, calenderViewDelegate>

@property UIBarButtonItem *lockBtn;
@property UIPopoverController *popover;

-(void)changed;

@end
