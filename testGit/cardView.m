//
//  cardView.m
//  Music Lesson Manager
//
//  Created by Alex Bechmann on 29/07/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "cardView.h"

@implementation cardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)updatePositionAnimated:(bool)animated{
    //[Tools removeShadowFromView:self];
    
    int column = 0;
    int row = 0;
    
    for (int c=0; c<self.cardIndex; c++) {
        row++;
        if (row == _rows){
            row = 0;
            column++;
        }
    }

    float xThird = self.parentView.bounds.size.width / _rows;
    float yThird = self.parentView.bounds.size.height / _columns;
    
    CGRect rect = CGRectMake(row*xThird, column*yThird, xThird,yThird);
    CGPoint cent = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    float animationDuration = 0;
    if (animated)
        animationDuration = 0.25;
    
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, rect.size.width - 10, rect.size.height-10);
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         self.center = cent;
                     }
                     completion:^(BOOL finished) {
                         //[Tools addShadowToViewWithView:self];
                         //self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
                     }];
    
}


-(void)createPositionAnimated:(bool)animated{
    int column = 0;
    int row = 0;
    
    for (int c=0; c<self.cardIndex; c++) {
        row++;
        if (row == _rows){
            row = 0;
            column++;
        }
    }
    
    float xThird = self.parentView.bounds.size.width / _rows;
    float yThird = self.parentView.bounds.size.height / _columns;
    
    CGRect rect = CGRectMake(row*xThird, column*yThird, xThird,yThird);
    CGPoint cent = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    float animationDuration = 0;
    if (animated)
        animationDuration = 0.15;
    
    self.frame = CGRectMake(rect.origin.x, rect.origin.y, 0, 0);
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.center = cent;
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - 10, rect.size.height-10);
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         self.center = cent;
                     }
                     completion:^(BOOL finished) {
                         [Tools addShadowToViewWithView:self];
                         //self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
                         
                     }];
}

-(void)view{
    self.isBeingViewed = YES;
    self.previousRect = self.frame;
    float xdiff = (_parentView.bounds.size.width - _parentView.bounds.size.width/1.2) /2;
    float ydiff = (_parentView.bounds.size.height - _parentView.bounds.size.height/1.2) /2;
    [self.parentView bringSubviewToFront:self];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         self.frame = CGRectMake(xdiff, ydiff, _parentView.bounds.size.width/1.2, _parentView.bounds.size.height/1.2);
                         
                     }
                     completion:^(BOOL finished) {
                         [Tools addLargeShadowToView:self];
                     }];
    
    
}

-(void)stopViewing{
    self.isBeingViewed = NO;
    [Tools removeShadowFromView:self];
    
    [UIView animateWithDuration:0.25
               animations:^{
                         self.frame = self.previousRect;
                     } completion:^(BOOL finished) {
                         
                         [Tools addShadowToViewWithView:self];
                     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
