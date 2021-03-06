//
//  lessonViewController.h
//  Music Lesson Manager
//
//  Created by Alex Bechmann on 29/07/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cardView.h"
#import "Lesson.h"
#import "DetailViewManager.h"
#import "Session.h"
#import "TextNote.h"
#import "AudioNote.h"

@protocol agendaDelegate <NSObject>
-(void)reloadData;
-(void)refreshViews;
@end

@interface lessonViewController : UIViewController <SubstitutableDetailViewController>

@property UIView *parentContainerView;
//@property int activeContainerView;

@property NSMutableArray *containerViews;
@property NSMutableArray *cardViews;
@property Lesson *lesson;
@property int lessonNumber;
@property int lessonTotal;
@property int activeContainer;

@property (weak, nonatomic) id<agendaDelegate> agendaDelegate;
@property (nonatomic, strong) UIBarButtonItem *navigationPaneBarButtonItem;
@property int rows;
@property int columns;

@property UIView *darkenView;
@property bool isEditing;

@end
