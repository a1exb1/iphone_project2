//
//  DatePickerViewController.h
//  Music Lesson Manager
//
//  Created by Alex Bechmann on 25/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectDateDelegate <NSObject>

-(void)sendBackDate:(NSDate *)date;

@end

@interface DatePickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSDate *date;
@property NSDate *minDate;

@property id<selectDateDelegate> delegate;

@end
