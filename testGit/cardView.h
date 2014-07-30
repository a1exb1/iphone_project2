//
//  cardView.h
//  Music Lesson Manager
//
//  Created by Alex Bechmann on 29/07/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"

@interface cardView : UIView

@property int cardIndex;
@property UIView *parentView;

-(void)updatePositionAnimated:(bool)animated;
-(void)createPositionAnimated:(bool)animated;
-(void)view;
-(void)stopViewing;

@property int rows;
@property int columns;
@property CGRect previousRect;

@end
