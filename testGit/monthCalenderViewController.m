//
//  monthCalenderViewController.m
//  PlanIt!
//
//  Created by Alex Bechmann on 16/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "monthCalenderViewController.h"

@interface monthCalenderViewController ()

@end

@implementation monthCalenderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setToolbarHidden:NO];
    
    if(_dayDate == NULL){
        _dayDate = [[NSDate alloc]init];
    }

    _calDate = [[NVDate alloc] initUsingDate:_dayDate];
    _todayDate = [[NSDate alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [Tools setModalSizeOfView:self.navigationController.view];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self drawSquaresWithDirection:0 andOldContainer:nil];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [Tools setModalSizeOfView:self.navigationController.view];
    [self drawSquaresWithDirection:0 andOldContainer:nil];
    
}

-(void)drawSquaresWithDirection:(int)direction andOldContainer: (UIView *)oldContainer
{
    NVDate *firstDateOfMonth = [[NVDate alloc] initUsingDate:_dayDate];
    [firstDateOfMonth firstDayOfMonth];
    NVDate *lastDateOfMonth = [[NVDate alloc] initUsingDate:_dayDate];
    [lastDateOfMonth lastDayOfMonth];
    
    NVDate *firstDateOfWeek = firstDateOfMonth;
    int goBack = 6 -[Tools currentDayOfWeekFromDate:firstDateOfMonth.date];
    NSLog(@"go back: %d", goBack);
    [firstDateOfWeek nextDays:-goBack];
    _firstDateOfCalender = firstDateOfWeek;
    
    self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 84);
    
    CGFloat verticalOffset = -22;
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.rightBarButtonItem setBackgroundVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem.leftBarButtonItem setBackgroundVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
        
    float left = 0;
    float top = 0;
    float height = 99;
    
    CGRect containerFrame = CGRectMake(0, 83, self.view.frame.size.width, (height * 6));
    UIView *container = [[UIView alloc] initWithFrame:containerFrame];
    container.layer.borderColor = [Tools colorFromHexString:@"#d8d8d8"].CGColor;
    container.layer.borderWidth = 1.0f;
    container.accessibilityValue = @"container";
    
    //nav views
    for(UIView *view in self.navigationController.navigationBar.subviews){
        if([view.accessibilityValue isEqualToString:@"dayTitle"]){
            [view removeFromSuperview];
        }
    }
    
    //container views
    if(direction == 0){
        for(UIView *view in self.view.subviews){
            if([view.accessibilityValue isEqualToString:@"container"]){
                [view removeFromSuperview];
            }
        }
    }
    

    [self.view addSubview:container];
    _currentCalenderView = container;
    
    NSString *addTitle = @"";
    
    NVDate *cellDate = _firstDateOfCalender;
    
    NVDate *todayDate = [[NVDate alloc] initUsingDate:_todayDate];
    NVDate *dayDate = [[NVDate alloc] initUsingDate:_dayDate];
    
    self.title = [Tools monthName:(int)dayDate.month];
    
    
    
    for (int i = 0; i<42; i++) {
        if (left == 7 || left == 14 || left == 21 || left == 28 || left == 35 || left == 42)
        {
            
            left = 0;
            top++;
        }
        
        if(i < 7){
            addTitle = [[Tools daysOfWeekArray] objectAtIndex:i];
        }
        
        float x = left * (self.view.frame.size.width/7);
        float y = (top * height);
        float width = (self.view.frame.size.width /7);
        
        CGRect frame = CGRectMake(x, y, width, height);
        monthCalenderCell *square = [[monthCalenderCell alloc] initWithFrame:frame];

        square.date = cellDate.date;
        square.layer.borderColor = [Tools colorFromHexString:@"#d8d8d8"].CGColor;
        square.layer.borderWidth = 0.25f;
        square.accessibilityValue = @"square";
        
        UIButton *selectSquareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, square.frame.size.width, square.frame.size.width)];
        [selectSquareBtn addTarget:self action:@selector(selectDay:) forControlEvents:UIControlEventTouchUpInside];
        [square addSubview:selectSquareBtn];
        
        CGRect dayNumberFrame = CGRectMake(((square.frame.size.width /2) -20), 20, 36, 36);
        UILabel *dayNumber = [[UILabel alloc] initWithFrame:dayNumberFrame];
        dayNumber.text = [NSString stringWithFormat:@"%ld", (long)cellDate.day];
        dayNumber.textAlignment = NSTextAlignmentCenter;
        dayNumber.textColor = [Tools colorFromHexString:@"#676767"];
        
        if (cellDate.month != [[NVDate alloc] initUsingDate:_dayDate].month){
            dayNumber.textColor = [Tools colorFromHexString:@"#cccccc"];
        }
      
        NSLog(@"%@", todayDate.date);
        
        if(cellDate.day   == todayDate.day &&
           cellDate.month == todayDate.month &&
           cellDate.year  == todayDate.year){
            dayNumber.backgroundColor = [UIColor blueColor];
            dayNumber.textColor = [UIColor whiteColor];
        }
        
        if(cellDate.day   == dayDate.day &&
           cellDate.month == dayDate.month &&
           cellDate.year  == dayDate.year){
            dayNumber.backgroundColor = [UIColor redColor];
            dayNumber.textColor = [UIColor whiteColor];
        }
        
        dayNumber.layer.cornerRadius = 18.0;
        dayNumber.layer.masksToBounds = YES;
        dayNumber.font = [UIFont fontWithName:nil size:15];
        
        [square addSubview:dayNumber];
        [container addSubview:square];
        
        //Label
        if(![addTitle isEqualToString:@""])
        {
            UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 37, width, 70)];
            dayLabel.text = addTitle;
            dayLabel.textAlignment = NSTextAlignmentCenter;
            dayLabel.font = [UIFont fontWithName:nil size:13];
            dayLabel.textColor = [Tools colorFromHexString:@"#9b9b9b"];
            dayLabel.accessibilityValue = @"dayTitle";
            [self.navigationController.navigationBar addSubview:dayLabel];
        }
        
        [cellDate nextDay];
        left++;
        addTitle = @"";

    }

    if(direction == 1){
        CGRect tempContainerFrame = container.frame;
        container.frame = CGRectMake((container.frame.origin.x - self.view.frame.size.width), container.frame.origin.y, container.frame.size.width, container.frame.size.height);
        
        [UIView animateWithDuration:0.6
                              delay:0.00
                            options:UIViewAnimationOptionCurveEaseOut
         
                         animations:^{
                             container.frame = tempContainerFrame;
                             oldContainer.frame = CGRectMake((container.frame.origin.x + self.view.frame.size.width), container.frame.origin.y, container.frame.size.width, container.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             [oldContainer removeFromSuperview];
                         }];
    }
    
    else if(direction == 2){
        CGRect tempContainerFrame = container.frame;
        container.frame = CGRectMake((container.frame.origin.x + self.view.frame.size.width), container.frame.origin.y, container.frame.size.width, container.frame.size.height);
        
        [UIView animateWithDuration:0.6
                              delay:0.00
                            options:UIViewAnimationOptionCurveEaseOut
         
                         animations:^{
                             container.frame = tempContainerFrame;
                             oldContainer.frame = CGRectMake((container.frame.origin.x - self.view.frame.size.width), container.frame.origin.y, container.frame.size.width, container.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             [oldContainer removeFromSuperview];
                         }];
    }
}

-(void)selectDay:(UIButton *)sender
{
    monthCalenderCell *cell = (monthCalenderCell *)sender.superview;
    NSLog(@"%@", cell.date);
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

-(void)previousMonth:(id)sender
{
    NVDate *tempDate = [[NVDate alloc] initUsingDate:_dayDate];
    [tempDate nextMonths:-1];
    _dayDate = tempDate.date;
    [self drawSquaresWithDirection:1 andOldContainer:_currentCalenderView];
}

-(void)nextMonth:(id)sender
{
    NVDate *tempDate = [[NVDate alloc] initUsingDate:_dayDate];
    [tempDate nextMonths:1];
    _dayDate = tempDate.date;
    [self drawSquaresWithDirection:2 andOldContainer:_currentCalenderView];
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
