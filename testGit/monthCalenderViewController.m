//
//  monthCalenderViewController.m
//  PlanIt!
//
//  Created by Alex Bechmann on 16/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "monthCalenderViewController.h"

@interface monthCalenderViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

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
    
    UIBarButtonItem *todayBtn = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(selectToday)];

    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] ;

    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    self.toolbarItems = [[NSArray alloc] initWithObjects:cancelBtn, flex, todayBtn, nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setModalSizeOfView];
    [self drawSquaresWithDirection:0 andOldContainer:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self drawSquaresWithDirection:0 andOldContainer:nil];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self setModalSizeOfView];
    
    
}

-(void)drawSquaresWithDirection:(int)direction andOldContainer: (UIView *)oldContainer
{
    NVDate *firstDateOfMonth = [[NVDate alloc] initUsingDate:_calDate.date];
    [firstDateOfMonth firstDayOfMonth];
    NVDate *lastDateOfMonth = [[NVDate alloc] initUsingDate:_calDate.date];
    [lastDateOfMonth lastDayOfMonth];
    
    NVDate *firstDateOfWeek = firstDateOfMonth;
    
    NSLog(@"first date of month %d", [Tools currentDayOfWeekFromDate:firstDateOfMonth.date]);
    
    int goBack;
    if([Tools currentDayOfWeekFromDate:firstDateOfMonth.date] == 0){
        goBack = 6;
    }
    else if([Tools currentDayOfWeekFromDate:firstDateOfMonth.date] == 1){
        goBack = 7;
    }
    else{
        goBack = [Tools currentDayOfWeekFromDate:firstDateOfMonth.date] - 1;
    }

    NSLog(@"go back: %d", goBack);
    [firstDateOfWeek nextDays:-goBack];
    _firstDateOfCalender = firstDateOfWeek;
    
    self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width,75);
    
    CGFloat verticalOffset = -27; //31 is same as default
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.rightBarButtonItem setBackgroundVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem.leftBarButtonItem setBackgroundVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
        
    float left = 0;
    float top = 0;
    float height = 100;
    
    CGRect containerFrame = CGRectMake(0, 74, self.view.frame.size.width, (height * 6));
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
    
    self.title = [NSString stringWithFormat:@"%@, %ld", [Tools monthName:(int)_calDate.month], (long)_calDate.year];
    
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
        
        [selectSquareBtn setBackgroundImage:[Tools imageWithColor:[UIColor grayColor] size:CGSizeMake(100, 100)] forState:UIControlStateSelected];
        [square addSubview:selectSquareBtn];
        
        CGRect dayNumberFrame = CGRectMake(((square.frame.size.width /2) -20), 20, 36, 36);
        UILabel *dayNumber = [[UILabel alloc] initWithFrame:dayNumberFrame];
        dayNumber.text = [NSString stringWithFormat:@"%ld", (long)cellDate.day];
        dayNumber.textAlignment = NSTextAlignmentCenter;
        dayNumber.textColor = [Tools colorFromHexString:@"#676767"];
        
        if (cellDate.month != _calDate.month){
            dayNumber.textColor = [Tools colorFromHexString:@"#cccccc"];
        }
        
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
        
        //Number of lessons label
        UILabel *lessonCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, square.frame.size.width, square.frame.size.height)];
        lessonCountLbl.textAlignment = NSTextAlignmentCenter;
        lessonCountLbl.font = [UIFont fontWithName:nil size:11];
        lessonCountLbl.textColor = [Tools colorFromHexString:@"#cccccc"];
        lessonCountLbl.text = @"5 lessons";
        
        [square addSubview:lessonCountLbl];
        [container addSubview:square];
        
        //Label
        if(![addTitle isEqualToString:@""])
        {
            UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 37, width, 45)];
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
        [self.monthCalenderDelegate sendDateToAgendaWithDate:cell.date];
    }];
}

-(void)selectToday
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.monthCalenderDelegate sendDateToAgendaWithDate:_todayDate];
    }];
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)previousMonth:(id)sender
{
    
    [_calDate nextMonths:-1];

    [self drawSquaresWithDirection:1 andOldContainer:_currentCalenderView];
}

-(void)nextMonth:(id)sender
{

    [_calDate nextMonths:1];

    [self drawSquaresWithDirection:2 andOldContainer:_currentCalenderView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setModalSizeOfView
{
    int longSide = 987;
    int shortSide = 717;
    
    UIView *view = self.navigationController.view;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        [view.superview setBounds:CGRectMake(0, 0, shortSide, longSide)];
    }
    else{
        [view.superview setBounds:CGRectMake(0, 0, longSide, shortSide)];
    }
    
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.2f
                          delay:0.00
                        options:UIViewAnimationOptionCurveEaseOut
     
                     animations:^{
                         if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
                         {
                             [view.superview setBounds:CGRectMake(0, 0, shortSide, longSide)];
                         }
                         else{
                             [view.superview setBounds:CGRectMake(0, 0, longSide, shortSide)];
                         }
                     }
                     completion:^(BOOL finished){
                         [self drawSquaresWithDirection:0 andOldContainer:nil];
                     }];
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
