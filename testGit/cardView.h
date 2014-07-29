//
//  cardView.h
//  Music Lesson Manager
//
//  Created by Alex Bechmann on 29/07/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cardView : UIView

@property int cardIndex;
@property UIView *parentView;

-(void)updatePositionAnimated:(bool)animated;

@end
