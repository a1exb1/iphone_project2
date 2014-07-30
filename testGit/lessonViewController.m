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

extern Session *session;

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

    if (_lessonTotal > 0) {
        self.title = [NSString stringWithFormat:@"Lesson %d of %d", _lessonNumber, _lessonTotal];
    }
    
    [session setShouldHideMasterInLandscape:NO];
    
    if ([[session client]clientID] == 0) {
        UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"]; //loginView monthCalView
        
        [self presentViewController:view animated:NO completion:nil];
    }
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([Tools isOrientationLandscape]) {
        _columns = 3;
        _rows = 3;
    }
    else{
        _columns = 4;
        _rows = 2;
    }
    
    self.cardViews = [[NSMutableArray alloc] init];
    
    //INFO CARD
    cardView *view = [[cardView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    view.parentView = self.view;
    view.columns = _columns;
    view.rows = _rows;
    view.cardIndex = 0;
    [view updatePositionAnimated:NO];
    view.backgroundColor = [UIColor redColor];
    
    //inside info card
    
    
    [self.cardViews addObject:view];
    
    view = [[cardView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    view.parentView = self.view;
    view.columns = _columns;
    view.rows = _rows;
    view.cardIndex = 1;
    [view updatePositionAnimated:NO];
    view.backgroundColor = [UIColor greenColor];
    [self.cardViews addObject:view];
    
    view = [[cardView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    view.parentView = self.view;
    view.columns = _columns;
    view.rows = _rows;
    view.cardIndex = 2;
    [view updatePositionAnimated:NO];
    view.backgroundColor = [UIColor grayColor];
    [self.cardViews addObject:view];

    for(cardView* view in self.cardViews){
        [self.view addSubview:view];
        UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handlePan:)];
        [view addGestureRecognizer:pgr];
    }
    
    [self renderCards];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if ([Tools isOrientationLandscape]) {
        _columns = 3;
        _rows = 3;
    }
    else{
        _columns = 4;
        _rows = 2;
    }
    [self renderCards];
}

-(void)renderCards{
    
    for(cardView* view in self.cardViews){
        view.columns = _columns;
        view.rows = _rows;
        [view updatePositionAnimated:YES];
    }

}

-(void)handlePan:(UIPanGestureRecognizer*)pgr;
{
    for (cardView *view in self.cardViews){
        if (pgr.state == UIGestureRecognizerStateChanged &&
            (CGRectContainsRect(self.view.bounds, view.bounds) )) {
            CGPoint center = pgr.view.center;
            CGPoint translation = [pgr translationInView:pgr.view];
            center = CGPointMake(center.x + translation.x,
                                 center.y + translation.y);
            pgr.view.center = center;

        }
        
        [pgr setTranslation:CGPointZero inView:pgr.view];
        
        if(pgr.state == UIGestureRecognizerStateEnded){
            CGPoint center = pgr.view.center;
            
            float xThird = self.view.bounds.size.width / _rows;
            float yThird = self.view.bounds.size.height / _columns;
            
            int column = 0;
            int row = 0;
            
            //get x pos
            
            for (int c = 0; c<_rows; c++) {
                if(center.x < (xThird *(c+1)) &&
                   center.x > (xThird *c)){
                    row = c;
                }
            }

            //get y pos
            for (int c = 0; c<_columns; c++) {
                if(center.y < (yThird *(c+1)) &&
                   center.y > (yThird *c)){
                    column = c;
                }
            }
            
            cardView *view = (cardView*)pgr.view;
            int previousCardIndex = view.cardIndex;
            view.cardIndex = (column * _rows) + row;
            [view updatePositionAnimated:YES];
            
            for(cardView* v in self.cardViews){
                
                if (v.cardIndex == view.cardIndex &&
                    v != view) {
                    //NSLog(@"%d %d", v.cardIndex, view.cardIndex);
                    v.cardIndex = previousCardIndex;
                    [v updatePositionAnimated:YES];
                }
            }
            
        }
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
