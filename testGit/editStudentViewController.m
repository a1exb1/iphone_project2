//
//  editStudentViewController.m
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "editStudentViewController.h"
#import "Student.h"

@interface editStudentViewController ()

@property (weak, nonatomic) IBOutlet UITextField *studentNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIButton *toSlotBtn;

@end

@implementation editStudentViewController

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
    self.studentNameTextField.text = [NSString stringWithFormat:@"%@", [_student name]];
    
    _saveResultArray = [[NSArray alloc] init];
    
    if([_student studentID] == 0) {
        self.title = @"New Student";
    }
    else{
        self.title = @"Edit Student";
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

-(IBAction)saveStudent:(id)sender
{
    
    
//    int newWeekday = (int)[_lessonTimePicker selectedRowInComponent:0] ;
//    int newHour = [[_HoursArray objectAtIndex:[_lessonTimePicker selectedRowInComponent:1 ]] intValue];
//    int newMins = [[_MinutesArray objectAtIndex:[_lessonTimePicker selectedRowInComponent:2 ]] intValue];
//    int newDuration = [[_DurationArray objectAtIndex:[_lessonTimePicker selectedRowInComponent:2 ]] intValue];
    
    //_newStudent = [[Student alloc] init];
    [_student setStudentID:[_student studentID]];
    [_student setName:self.studentNameTextField.text];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //http://localhost:59838/mobileapp/save_data.aspx?datatype=student&id=29&name=hellofromquery2
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=student&id=%li&name=%@&ts=%f", [_student studentID], [_student name], [[NSDate date] timeIntervalSince1970]];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest: request delegate:self];

    
//    StudentCourseLink *newStudentCourseLink = [[StudentCourseLink alloc] init];
//    [newStudentCourseLink setWeekday:newWeekday];
//    [newStudentCourseLink setHour:newHour];
//    [newStudentCourseLink setHour:newMins];
//    [newStudentCourseLink setHour:newDuration];
//    [newStudent setStudentCourseLink:newStudentCourseLink];
    
    _saveResultArray = [[NSArray alloc] init];
    
    //needs to save this
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    _saveResultArray = [NSJSONSerialization JSONObjectWithData:_data options:nil error:nil];
    
    if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"1"])
    {
        if ([_student studentID] == 0) {
            [_student setStudentID:[[[_saveResultArray objectAtIndex:0] objectForKey:@"studentid" ] intValue]];
            
            [self performSegueWithIdentifier:@"editStudentToEditSlot" sender:self];
        }
        else{
            [self.editStudentDelegate updatedStudent:
             _student];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
        
    }
    else{
        self.statusLbl.text = @"Error with saving";
        self.statusLbl.hidden = NO;
        
        //self.toSlotBtn.textInputContextIdentifier = @"";
        self.toSlotBtn.hidden = NO;
        
    }

}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    editLessonSlotViewController *view = segue.destinationViewController;
    
    // do any setup you need for myNewVC
    view.student = _student;
    
}



@end
