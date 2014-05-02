//
//  editStudentViewController.h
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentCourseLink.h"
#import "editLessonSlotViewController.h"

@protocol editStudentDelegate <NSObject>

-(void)updatedSlot:(StudentCourseLink *)studentCourseLink;

@end

@interface editStudentViewController : UIViewController

@property NSString *studentID;
@property StudentCourseLink *studentCourseLink;

@property NSMutableData *data;
@property NSArray *saveResultArray;

@property (weak, nonatomic) id<editStudentDelegate> editStudentDelegate;


@end
