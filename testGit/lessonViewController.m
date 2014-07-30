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
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNote)];
    
    self.navigationItem.rightBarButtonItem = addBtn;
    
    self.darkenView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.darkenView.backgroundColor = [UIColor colorWithRed:55 green:55 blue:55 alpha:0];
}

-(void)addNote{
    //note
    if ((int)[self.cardViews count] < 9) {
        cardView *view = [[cardView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
        view.parentView = self.view;
        view.columns = _columns;
        view.rows = _rows;

        bool done = NO;
        for (int c=0; c<9; c++) {
            bool allowed = YES;
            if (!done) {
                for (cardView *view in self.cardViews){
                    if (view.cardIndex == c) {
                        allowed = NO;
                    }
                }
                if (allowed) {
                    done = YES;
                    view.cardIndex = c;
                }
            }
        }
        
        [view createPositionAnimated:YES];
        view.backgroundColor = [Tools colorFromHexString:@"#ffe400"];
        
        //inside
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        [btn setTitle:@"view" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(view:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UIButton *stopViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 100, 50)];
        [stopViewBtn setTitle:@"stop view" forState:UIControlStateNormal];
        [stopViewBtn addTarget:self action:@selector(stopViewing:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:stopViewBtn];
        
        [self.cardViews addObject:view];
        [self.view addSubview:view];
        UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handlePan:)];
        [view addGestureRecognizer:pgr];
    }
    
    else{
        NSLog(@"not more space");
    }
    
    
}

-(void)view:(UIButton*)btn{
    cardView *view = (cardView*)btn.superview;
    [self.view addSubview:self.darkenView];
    [view view];

    self.darkenView.backgroundColor = [UIColor colorWithRed:55 green:55 blue:55 alpha:0];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.darkenView.backgroundColor = [UIColor colorWithRed:55 green:55 blue:55 alpha:0.8];
                     } completion:^(BOOL finished) {
                         
                     }];
}

-(void)stopViewing:(UIButton*)btn{
    cardView *view = (cardView*)btn.superview;
    [view stopViewing];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.darkenView.backgroundColor = [UIColor colorWithRed:55 green:55 blue:55 alpha:0];
                     } completion:^(BOOL finished) {
                         [self.darkenView removeFromSuperview];
                     }];
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([Tools isOrientationLandscape]) {
        _columns = 3;
        _rows = 3;
    }
    else{
        _columns = 5;
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
    view.backgroundColor = [UIColor whiteColor]; //eaeaea
    
    //student image
    UIImageView *studentImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    studentImg.center = view.center;
    studentImg.image = [UIImage imageNamed:@"user_large.png"];
    [view addSubview:studentImg];
    
    
    //student name
    UILabel *studentNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, view.frame.size.width - 20, 20)];
    studentNameLbl.text = self.lesson.student.name;
    [view addSubview:studentNameLbl];
    studentNameLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.cardViews addObject:view];
    
    
    // course?
    view = [[cardView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    view.parentView = self.view;
    view.columns = _columns;
    view.rows = _rows;
    view.cardIndex = 1;
    [view updatePositionAnimated:NO];
    view.backgroundColor = [UIColor whiteColor];
    [self.cardViews addObject:view];
    
    
    //note
    view = [[cardView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    view.parentView = self.view;
    view.columns = _columns;
    view.rows = _rows;
    view.cardIndex = 2;
    [view updatePositionAnimated:NO];
    view.backgroundColor = [Tools colorFromHexString:@"#ffe400"];
    [self.cardViews addObject:view];

    
    //note text label
    UITextView *noteText = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    noteText.text = @"hello this is a long note which can go onto mulitple lines :)";
    noteText.backgroundColor = [UIColor clearColor];
    [noteText setEditable:NO];
    [view addSubview:noteText];
    
    //to put in front of notetextview
    //? only can drag down
    UIView *block = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    block.backgroundColor = [UIColor clearColor];
    [view addSubview:block];
    
    for(cardView* view in self.cardViews){
        [self.view addSubview:view];
        UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handlePan:)];
        [view addGestureRecognizer:pgr];
        //[Tools addShadowToViewWithView:view];
    }
    
    [self renderCards];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if ([Tools isOrientationLandscape]) {
        _columns = 3;
        _rows = 3;
    }
    else{
        _columns = 5;
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
    int previousCardIndex;
    
    for (cardView *view in self.cardViews){
        if (pgr.state == UIGestureRecognizerStateChanged &&
            (CGRectContainsRect(self.view.bounds, view.bounds) )) {
            CGPoint center = pgr.view.center;
            CGPoint translation = [pgr translationInView:pgr.view];
            center = CGPointMake(center.x + translation.x,
                                 center.y + translation.y);
            pgr.view.center = center;
            
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
            [self.view bringSubviewToFront:view];
            previousCardIndex = view.cardIndex;
            
            int newCardIndex = (column * _rows) + row;
            
            if (newCardIndex == 9)
                newCardIndex = previousCardIndex;
            
            view.cardIndex = newCardIndex;
            
            for(cardView* v in self.cardViews){
                
                if (v.cardIndex == view.cardIndex &&
                    v != view) {
                    //NSLog(@"%d %d", v.cardIndex, view.cardIndex);
                    v.cardIndex = previousCardIndex;
                    [v updatePositionAnimated:YES];
                }
            }
        }
        
        [pgr setTranslation:CGPointZero inView:pgr.view];
        
        if(pgr.state == UIGestureRecognizerStateEnded){
            for(cardView* v in self.cardViews){
                [v updatePositionAnimated:YES];
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
