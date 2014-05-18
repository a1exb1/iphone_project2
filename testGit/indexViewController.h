//
//  indexViewController.h
//  testGit
//
//  Created by Alex Bechmann on 17/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"
#import "NVDate.h"

@interface indexViewController : UIViewController 

@property Lesson *lesson;
@property bool loaded;
@property NSTimer *timer;


@end
