//
//  AddLessonsViewController.h
//  testGit
//
//  Created by Thomas Kjær Christensen on 14/05/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"
#import "Tools.h"
#import "NVDate.h"
#import "DetailViewController.h"

@interface AddLessonsViewController : UIViewController <SubstitutableDetailViewController>

@property bool shouldClear;
@property NSArray *lessons;
@property NSMutableData *data;

@property NSArray *resultArray;

@property (nonatomic, strong) UIBarButtonItem *navigationPaneBarButtonItem;

@end
