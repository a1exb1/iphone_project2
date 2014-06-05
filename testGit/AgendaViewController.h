//
//  AgendaViewController.h
//  testGit
//
//  Created by Alex Bechmann on 06/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"
#import "SelectDateViewController.h"
#import "MZDayPicker.h"
#import "DIDatepicker.h"
#import "indexViewController.h"
#import "DetailViewController.h"



@interface AgendaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SelectDateDelegate, MZDayPickerDataSource, MZDayPickerDelegate, agendaDelegate>

@property NSArray *lessons;
@property NSMutableData *data;

@property Tutor *tutor;
@property Lesson *lessonSender;
@property bool editing;

@property NSDate *dayDate;
@property (weak, nonatomic) IBOutlet MZDayPicker *dayPicker;

@property (weak, nonatomic) IBOutlet DIDatepicker *datePicker;

@property int counter;

@property int NSURLType;

@property bool keepEditing;

@property (strong, nonatomic) DetailViewController *detailViewController;

@property UIBarButtonItem *clipboardItem;

@property NSIndexPath *indexPath;

@property int requestNumber;
@property int dataRequestNumber;

@end
