//
//  editTutorsListViewController.h
//  testGit
//
//  Created by Alex Bechmann on 03/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tutor.h"

@interface editTutorsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSArray *tutors;
@property NSMutableData *data;

//@property Tutor *tutor;
@property Tutor *tutorSender;

@end
