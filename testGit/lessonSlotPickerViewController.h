//
//  lessonSlotPickerViewController.h
//  Music Lesson Manager
//
//  Created by Alex Bechmann on 26/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentCourseLink.h"

@protocol pickerDelegate <NSObject>
-(void)sendBackLessonSlot:(StudentCourseLink*)link;
@end

@interface lessonSlotPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property UIPickerView *picker;
@property StudentCourseLink *link;
@property id<pickerDelegate> delegate;

@end
