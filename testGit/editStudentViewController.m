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
@property (weak, nonatomic) IBOutlet UITextField *studentPhoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

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
    self.studentNameTextField.text = [NSString stringWithFormat:@"%@", [[_studentCourseLink student] name]];
    
    _saveResultArray = [[NSArray alloc] init];
    
    if([[_studentCourseLink student] studentID] == 0) {
        self.title = @"Create student";
        self.deleteBtn.hidden = YES;
    }
    else{
        self.title = @"Edit student info";
    }
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveStudent)];
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteStudent)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveBtn, deleteBtn, nil]];
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

-(void)saveStudent
{
    self.statusLbl.hidden = YES;
    [[_studentCourseLink student] setName:self.studentNameTextField.text];
    [[_studentCourseLink student] setPhone:self.studentPhoneTextField.text];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //http://localhost:59838/mobileapp/save_data.aspx?datatype=student&id=29&name=hellofromquery2
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=student&id=%li&name=%@&phone=%@&clientid=%i&ts=%f", [[_studentCourseLink student] studentID], [[_studentCourseLink student]name], [[_studentCourseLink student] phone], 1, [[NSDate date] timeIntervalSince1970]];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    _saveResultArray = [[NSArray alloc] init];
}


-(void)deleteStudent
{
    self.statusLbl.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //http://localhost:59838/mobileapp/save_data.aspx?datatype=student&id=29&name=hellofromquery2
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=student&id=%li&delete=1&clientid=%i&ts=%f", [[_studentCourseLink student] studentID], 1, [[NSDate date] timeIntervalSince1970]];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    _saveResultArray = [[NSArray alloc] init];
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
    _saveResultArray = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"1"])
    {
        if ([[_studentCourseLink student] studentID] == 0) {
            [[_studentCourseLink student] setStudentID:[[[_saveResultArray objectAtIndex:0] objectForKey:@"studentid" ] intValue]];

            [self performSegueWithIdentifier:@"editStudentToEditSlot" sender:self];
        }
        else{
            [self.editStudentDelegate updatedSlot: _studentCourseLink];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"0"])
    {
        self.statusLbl.text = @"Error with saving";
        self.statusLbl.hidden = NO;
        self.toSlotBtn.hidden = NO;
    }
    
    else if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"3"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }
    else{
        self.statusLbl.text = @"Error with saving";
        self.statusLbl.hidden = NO;
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    editLessonSlotViewController *view = segue.destinationViewController;
    view.studentCourseLink = _studentCourseLink;
    view.popViews = 2;
}



@end
