//
//  lessonViewController.m
//  Music Lesson Manager
//
//  Created by Alex Bechmann on 29/07/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "lessonViewController.h"

@interface lessonViewController ()

@end

@implementation lessonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 200, 100)];
    self.view1.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.view1];
    
    UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handlePan:)];
    [self.view1 addGestureRecognizer:pgr];
}

-(void)handlePan:(UIPanGestureRecognizer*)pgr;
{
    if (pgr.state == UIGestureRecognizerStateChanged &&
        (CGRectContainsRect(self.view.bounds, self.view1.bounds) )) {
        CGPoint center = pgr.view.center;
        CGPoint translation = [pgr translationInView:pgr.view];
        center = CGPointMake(center.x + translation.x,
                             center.y + translation.y);
        pgr.view.center = center;
        
    }
    
    [pgr setTranslation:CGPointZero inView:pgr.view];
    
    if(pgr.state == UIGestureRecognizerStateEnded){
        CGPoint center = pgr.view.center;
        
        float xThird = self.view.bounds.size.width / 3;
        float leftEdge = 0;
        float rightEdge = self.view.bounds.size.width;
        
        float yThird = self.view.bounds.size.height / 3;
        float bottomEdge = 0;
        float topEdge = self.view.bounds.size.height;
        
        int column = 0;
        int row = 0;
        
        //get x pos
        if (center.x < xThird) {
            row = 0;
        }
        if (center.x > xThird &&
            center.x < (xThird *2)) {
            row = 1;
        }
        else if(center.x > (xThird *2)){
            row = 2;
        }
        
        //get y pos
        if (center.y < yThird) {
            column = 0;
        }
        if (center.y > yThird &&
            center.y < (yThird *2)) {
            column = 1;
        }
        else if(center.y > (yThird *2)){
            column = 2;
        }
        
        CGRect rect = CGRectMake(row*xThird, column*yThird, xThird,yThird);
        CGPoint cent = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                             pgr.view.center = cent;
                         }];
        
        
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
