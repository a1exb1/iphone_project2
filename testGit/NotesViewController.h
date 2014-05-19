//
//  NotesViewController.h
//  testGit
//
//  Created by Alex Bechmann on 07/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"
#import "Tools.h"

@interface NotesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *notes;
@property Lesson *lesson;

@property NSArray *allNotes;
@property NSMutableData *data;

@property NSMutableArray *thisLessonNotes;
@property NSMutableArray *otherLessonNotes;

@end
