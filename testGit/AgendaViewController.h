//
//  AgendaViewController.h
//  testGit
//
//  Created by Alex Bechmann on 06/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"
#import "SelectDateViewController.h"


@interface AgendaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SelectDateDelegate>

@property NSArray *lessons;
@property NSMutableData *data;

@property Tutor *tutor;
@property Lesson *lessonSender;
@property bool editing;

@property NSDate *dayDate;

@end
