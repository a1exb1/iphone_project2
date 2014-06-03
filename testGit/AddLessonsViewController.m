//
//  AddLessonsViewController.m
//  testGit
//
//  Created by Thomas Kjær Christensen on 14/05/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "AddLessonsViewController.h"

@interface AddLessonsViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *fromDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *toDatePicker;

@end

@implementation AddLessonsViewController

extern Session *session;

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

    NSLog(@"%@", self.fromDatePicker.date);
    
    NVDate *date = [[NVDate alloc] initUsingToday];
    [date nextMonths:3];
    
    NSDate *inThreeMonths = date.date;
    
    self.toDatePicker.date = inThreeMonths;
    
    if (_shouldClear == YES) {
        UIBarButtonItem *clearBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(jsonRequestGetData)];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:clearBtn, nil]];
    }
    else {
        UIBarButtonItem *clearBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(jsonRequestGetData)];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:clearBtn, nil]];
    }
    
    self.title = @"Add lessons";
    
}



-(void)jsonRequestGetData
{


    _data = [[NSMutableData alloc]init];
    _lessons = [[NSArray alloc] init];

    NVDate *fromDate = [[NVDate alloc] initUsingDate:self.fromDatePicker.date];
    NVDate *toDate = [[NVDate alloc] initUsingDate:self.toDatePicker.date];
    
    NSString *fromDateString = [[NSString alloc] initWithFormat:@"%02ld/%02ld/%li", (long)fromDate.day, (long)fromDate.month, (long)fromDate.year ];
    
    NSString *toDateString = [[NSString alloc] initWithFormat:@"%02ld/%02ld/%li", (long)toDate.day, (long)toDate.month, (long)toDate.year ];
    
    NSString *function = @"createlessons";
    if(_shouldClear == YES){
        function = @"clearlessons";
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=%@&id=%li&datefrom=%@&dateto=%@&ts=%f", function, [[session tutor] tutorID], fromDateString, toDateString, [[NSDate date] timeIntervalSince1970]];
    
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc]init];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    [_data appendData:theData];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [Tools hideLoader];
    
    _resultArray = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    if ([_resultArray count] == 0) {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorView show];

    }
    else{
        if([[[_resultArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1" ]){
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        else{
            UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Lesson saving failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorView show];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [Tools hideLoader];
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
