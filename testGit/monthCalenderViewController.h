//
//  monthCalenderViewController.h
//  PlanIt!
//
//  Created by Alex Bechmann on 16/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"

@interface monthCalenderViewController : UIViewController

-(IBAction)previousMonth:(id)sender;
-(IBAction)nextMonth:(id)sender;

@property UIView *currentCalenderView;

@end
