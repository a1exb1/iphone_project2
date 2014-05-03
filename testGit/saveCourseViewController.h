//
//  saveCourseViewController.h
//  testGit
//
//  Created by Alex Bechmann on 03/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "Tutor.h"

@interface saveCourseViewController : UIViewController


@property Course *course;
@property Tutor *tutor;

@property NSMutableData *data;
@property NSArray *saveResultArray;

@end
