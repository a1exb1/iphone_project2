//
//  PickerViewController.h
//  Music Lesson Manager
//
//  Created by Alex Bechmann on 25/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pickerDelegate <NSObject>
-(void)sendBackInt:(int)number;
@end

@interface PickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property int number;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property NSArray *dataArray;

@property id<pickerDelegate> delegate;

@end
