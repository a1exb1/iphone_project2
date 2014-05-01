//
//  editLessonSlotViewController.h
//  testGit
//
//  Created by Alex Bechmann on 29/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "ABAppDelegate.h"
@interface editLessonSlotViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property Student *student;
@property NSArray *weekdayArray;
@property NSArray *HoursArray;
@property NSArray *MinutesArray;
@property NSArray *DurationArray;
@property NSArray *ComponentsArray;
@property NSMutableData *data;
@property NSArray *saveResultArray;

-(IBAction)save:(id)sender;


@end
