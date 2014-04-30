//
//  editStudentViewController.h
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "editLessonSlotViewController.h"

@protocol editStudentDelegate <NSObject>

-(void)updatedStudent:(Student *)student;

@end

@interface editStudentViewController : UIViewController

@property NSString *studentID;
@property Student *student;

@property NSMutableData *data;
@property NSArray *saveResultArray;

@property (weak, nonatomic) id<editStudentDelegate> editStudentDelegate;


@end
