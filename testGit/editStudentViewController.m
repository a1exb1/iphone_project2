//
//  editStudentViewController.m
//  testGit
//
//  Created by Alex Bechmann on 25/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "editStudentViewController.h"
#import "Student.h"
#import "Tools.h"
#import "Session.h"

@interface editStudentViewController ()

@property (weak, nonatomic) IBOutlet UITextField *studentNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIButton *toSlotBtn;
@property (weak, nonatomic) IBOutlet UITextField *studentPhoneTextField;

@end

@implementation editStudentViewController

extern Session *session;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if(![Tools isIpad])
    {
        [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:[Tools colorFromHexString:@"#4473b4"] andTint:[UIColor whiteColor] theme:@"dark"];
    }
    if(![self.accessibilityValue isEqualToString:@"coursePopover"])
    {
        self.preferredContentSize = CGSizeMake(320, 568);
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    self.studentNameTextField.text = [NSString stringWithFormat:@"%@", [[_studentCourseLink student] name]];
    self.studentPhoneTextField.text = [NSString stringWithFormat:@"%@", [[_studentCourseLink student] phone]];
    
    _saveResultArray = [[NSArray alloc] init];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveStudent)];
    
    if([[_studentCourseLink student] studentID] == 0) {
        self.title = @"Create student";
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveBtn, nil]];
    }
    else{
        self.title = @"Edit student info";
        UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(authorizeDelete)];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveBtn, deleteBtn, nil]];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        [self deleteStudent];
        
    }

}

-(void)authorizeDelete{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm delete"
                                                    message:@"Are you sure you want to delete?"
                                                   delegate:self    // <------
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete student", nil];
    [alert show];
}

-(void)saveStudent
{
    self.statusLbl.hidden = YES;
    [[_studentCourseLink student] setName:self.studentNameTextField.text];
    [[_studentCourseLink student] setPhone:self.studentPhoneTextField.text];
    
    [Tools showLoader];
    //http://localhost:59838/mobileapp/save_data.aspx?datatype=student&id=29&name=hellofromquery2
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=student&id=%li&name=%@&phone=%@&clientid=%li&ts=%f", [[_studentCourseLink student] studentID], [[_studentCourseLink student]name], [[_studentCourseLink student] phone], [[session client] clientID], [[NSDate date] timeIntervalSince1970]];
    
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
    [Tools showLoader];
    //http://localhost:59838/mobileapp/save_data.aspx?datatype=student&id=29&name=hellofromquery2
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=student&id=%li&delete=1&clientid=%li&ts=%f", [[_studentCourseLink student] studentID], [[session client] clientID], [[NSDate date] timeIntervalSince1970]];
    
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
    [Tools hideLoader];
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
    [Tools hideLoader];
}
//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    editLessonSlotViewController *view = segue.destinationViewController;
    view.studentCourseLink = _studentCourseLink;
    view.popViews = 2;
}



@end
