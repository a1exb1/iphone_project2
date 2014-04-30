//
//  viewAllStudentsViewController.h
//  testGit
//
//  Created by Alex Bechmann on 30/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface viewAllStudentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property Student *student;
@property NSArray *students;
@property NSMutableData *data;
@property Student *studentSender;

@end
