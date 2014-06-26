//
//  lessonSlotPickerViewController.h
//  Music Lesson Manager
//
//  Created by Alex Bechmann on 26/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentCourseLink.h"

@protocol lessonSlotPickerDelegate <NSObject>
-(void)sendBackLessonSlot:(StudentCourseLink*)link;
@end

@interface lessonSlotPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>


@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property StudentCourseLink *link;
@property id<lessonSlotPickerDelegate> delegate;

@end
