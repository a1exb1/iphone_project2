//
//  calenderViewController.h
//  PlanIt!
//
//  Created by Alex Bechmann on 28/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"


#import "AddLessonsViewController.h"

@interface calenderViewController : UIViewController <UIWebViewDelegate>

@property UIBarButtonItem *lockBtn;

-(void)changed;

@end
