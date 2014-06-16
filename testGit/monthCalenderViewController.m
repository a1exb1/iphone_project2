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
    
    
    
    

    
     //self.title. = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height + 40);
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self drawSquares];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self drawSquares];
}

-(void)drawSquares
{
    self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height + 40);
    
    CGFloat verticalOffset = -22;
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    
    float left = 0;
    float top = 0;
    float height = 100;
    
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
    for(UIView *view in self.view.subviews){
        if([view.accessibilityValue isEqualToString:@"container"]){
            [view removeFromSuperview];
        }
    }

    [self.view addSubview:container];
    
    NSString *addTitle = @"";
    
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
        UIView *square = [[UIView alloc] initWithFrame:frame];
        square.layer.borderColor = [Tools colorFromHexString:@"#d8d8d8"].CGColor;
        square.layer.borderWidth = 0.25f;
        square.accessibilityValue = @"square";
        
        CGRect dayNumberFrame = CGRectMake(((square.frame.size.width /2) -20), 20, 36, 36);
        UILabel *dayNumber = [[UILabel alloc] initWithFrame:dayNumberFrame];
        dayNumber.text = [NSString stringWithFormat:@"%d", i];
        dayNumber.textAlignment = NSTextAlignmentCenter;
        dayNumber.textColor = [Tools colorFromHexString:@"#676767"];
        
        if(i == 26){
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
            UITextField *textfieldTxt = [[UITextField alloc]initWithFrame:CGRectMake(x, 35, width, 70)];
            textfieldTxt.text = addTitle;
            textfieldTxt.textAlignment = NSTextAlignmentCenter;
            textfieldTxt.font = [UIFont fontWithName:nil size:13];
            textfieldTxt.textColor = [Tools colorFromHexString:@"#9b9b9b"];
            textfieldTxt.accessibilityValue = @"dayTitle";
            [self.navigationController.navigationBar addSubview:textfieldTxt];
            
            
            
        }
        
        left++;
        addTitle = @"";
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
