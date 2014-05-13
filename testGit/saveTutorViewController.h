//
//  saveTutorViewController.h
//  testGit
//
//  Created by Alex Bechmann on 02/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tutor.h"

@interface saveTutorViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property Tutor *tutor;

@property NSMutableData *data;
@property NSArray *saveResultArray;

@property NSArray *ComponentsArray;

@end
