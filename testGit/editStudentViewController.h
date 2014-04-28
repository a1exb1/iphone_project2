//
//  editStudentViewController.h
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
@interface editStudentViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property NSString *studentID;
@property Student *student;
@property NSArray *weekdayArray;
@property NSArray *HoursArray;
@property NSArray *MinutesArray;
@property NSArray *DurationArray;
@property NSArray *ComponentsArray;
@end
