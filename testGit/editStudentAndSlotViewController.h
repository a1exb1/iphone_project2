//
//  editStudentAndSlotViewController.h
//  testGit
//
//  Created by Alex Bechmann on 29/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentCourseLink.h"
#import "editStudentViewController.h"
#import "editLessonSlotViewController.h"

@interface editStudentAndSlotViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, editLessonSlotDelegate, editStudentDelegate>

@property StudentCourseLink *studentCourseLink;
@property NSArray *cells;


@end
