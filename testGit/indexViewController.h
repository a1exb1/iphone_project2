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
//#import "AgendaViewController.h"

@protocol agendaDelegate <NSObject>

-(void)reloadData;

@end

@interface indexViewController : UIViewController <UISplitViewControllerDelegate>

@property Lesson *lesson;
@property bool loaded;
@property NSTimer *timer;

@property (weak, nonatomic) IBOutlet UISegmentedControl *attendenceControl;

@property NSArray *resultArray;
@property NSMutableData *data;

@property UIBarButtonItem *menuBtn;
@property UIBarButtonItem *detailShowMasterButton;

-(void)updateLabels;
-(void)changed;

@property (weak, nonatomic) id<agendaDelegate> agendaDelegate;

@end
