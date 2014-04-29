//
//  editStudentAndSlotViewController.h
//  testGit
//
//  Created by Alex Bechmann on 29/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface editStudentAndSlotViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property Student *student;
@property NSArray *cells;


@end
