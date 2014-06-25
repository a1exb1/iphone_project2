//
//  calenderItemTableViewController.h
//  Music Lesson Manager
//
//  Created by Alex Bechmann on 25/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"



@interface calenderItemTableViewController : UITableViewController  <UITableViewDataSource, UITableViewDelegate>

@property Lesson *lesson;
//@property id<calDelegate> delegate;

@property NSDate *dayDate;

@end
