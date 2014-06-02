//
//  DetailViewController.h
//  MasterDetail1
//
//  Created by Alex Bechmann on 20/03/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lesson.h"
#import "indexViewController.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property UIBarButtonItem *detailShowMasterButton;

-(void)changed;

-(void)goToAgendaWithLesson:(Lesson *)lesson;

@property Lesson *lessonSender;

@end
