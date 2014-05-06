//
//  AgendaViewController.h
//  testGit
//
//  Created by Alex Bechmann on 06/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentCourseLink.h"


@interface AgendaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSArray *lessons;
@property NSMutableData *data;

@property Tutor *tutor;
@property StudentCourseLink *studentCourseLinkSender;

@end
