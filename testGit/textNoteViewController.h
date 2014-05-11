//
//  textNoteViewController.h
//  testGit
//
//  Created by Alex Bechmann on 10/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"
#import "TextNote.h"

@interface textNoteViewController : UIViewController

@property Lesson *lesson;
@property TextNote *note;

@property NSMutableData *data;
@property NSArray *saveResultArray;
@property NSArray *noteSaveArray;

@end
