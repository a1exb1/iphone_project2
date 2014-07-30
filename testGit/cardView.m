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
    }
    return self;
}

-(void)updatePositionAnimated:(bool)animated{
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
