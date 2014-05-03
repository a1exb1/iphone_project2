//
//  editLessonSlotViewController.h
//  testGit
//
//  Created by Alex Bechmann on 29/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentCourseLink.h"

@protocol editLessonSlotDelegate <NSObject>

-(void)updatedSlot:(StudentCourseLink *)studentCourseLink;

@end

@interface editLessonSlotViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property StudentCourseLink *studentCourseLink;
@property NSArray *weekdayArray;
@property NSArray *HoursArray;
@property NSArray *MinutesArray;
@property NSArray *DurationArray;
@property NSArray *ComponentsArray;
@property NSMutableData *data;
@property NSArray *saveResultArray;

@property int popViews;



@property (weak, nonatomic) id<editLessonSlotDelegate> editLessonSlotDelegate;
@end
