//
//  saveTutorViewController.m
//  testGit
//
//  Created by Alex Bechmann on 02/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "saveTutorViewController.h"
#import "Tools.h"
#import "Session.h"

@interface saveTutorViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UITextField *clientUserNameLbl;
@property (weak, nonatomic) IBOutlet UITextField *usernameLbl;
@property (weak, nonatomic) IBOutlet UIPickerView *accountTypePicker;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation saveTutorViewController

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
    if (![Tools isIpad]) {
        [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:[Tools colorFromHexString:@"#b44444"] andTint:[UIColor whiteColor] theme:@"dark"];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self rotateValues];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.accountTypePicker setDataSource:self];
    [self.accountTypePicker setDelegate:self];

    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    if([_tutor tutorID] > 0 && [_tutor accountType] > 0){
        UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(authorizeDelete)];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveBtn, deleteBtn, nil]];
    }
    else{
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveBtn, nil]];
    }
    
    //self.accountTypePicker.hidden = YES;
//    if ([[session tutor] accountType] < 2) {
//        self.accountTypePicker.hidden = NO;
//    }
    
    self.nameTextField.text = [_tutor name];
    self.phoneTextField.text = [_tutor phone];
    
    NSString *clientUserNameWithDot = [NSString stringWithFormat:@"%@.", [[session client] clientUserName]];
    self.clientUserNameLbl.text = clientUserNameWithDot;
    
    NSString *strippedUsername = [[NSString alloc] init];
    strippedUsername = [[_tutor username] stringByReplacingOccurrencesOfString:clientUserNameWithDot withString:@""];
    
    self.usernameLbl.text = strippedUsername;
    
    if([_tutor tutorID] == 0){
        self.title = @"Create tutor";
    }
    else{
        self.title = @"Edit tutor";
    }
    
    if ([_tutor accountType] == 0) {
        NSLog(@"%d", [_tutor accountType]);
        _ComponentsArray = [[NSArray alloc] initWithObjects:@"Owner", nil];
        [self.accountTypePicker selectRow:[_tutor accountType] inComponent:0 animated:YES];
    }
    else{
        _ComponentsArray = [[NSArray alloc] initWithObjects:@"Administrator", @"Standard", nil];
        [self.accountTypePicker selectRow:([_tutor accountType] - 1) inComponent:0 animated:YES];
    }
    
    self.passwordTextField.text = [_tutor password];
    
}

-(void)rotateValues
{
//    [self.accountTypePicker setFrame:CGRectMake(0, self.accountTypePicker.frame.origin.y, self.view.frame.size.width, self.accountTypePicker.frame.size.height)];
//    
//    [self.nameTextField setFrame:CGRectMake(((self.view.frame.size.width - self.nameTextField.frame.size.width)/2), self.nameTextField.frame.origin.y, self.nameTextField.frame.size.width, self.nameTextField.frame.size.height)];
//    [self.phoneTextField setFrame:CGRectMake(((self.view.frame.size.width - self.phoneTextField.frame.size.width)/2), self.phoneTextField.frame.origin.y, self.phoneTextField.frame.size.width, self.phoneTextField.frame.size.height)];
//    [self.phoneTextField setFrame:CGRectMake(((self.view.frame.size.width - self.phoneTextField.frame.size.width)/2), self.phoneTextField.frame.origin.y, self.phoneTextField.frame.size.width, self.phoneTextField.frame.size.height)];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self rotateValues];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        [self delete];
    }
}

-(void)authorizeDelete{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm delete"
                                                    message:@"Are you sure you want to delete?"
                                                   delegate:self    // <------
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete tutor", nil];
    [alert show];
}

-(void)save{
    if (self.nameTextField.text && self.nameTextField.text.length > 0 && ![self.passwordTextField.text isEqualToString:@""]) {
        
        [Tools showLoader];
        
        [_tutor setName:self.nameTextField.text];
        [_tutor setPhone:self.phoneTextField.text];
    
        self.statusLbl.hidden = YES;
    
        NSString *username = [NSString stringWithFormat:@"%@%@", self.clientUserNameLbl.text, self.usernameLbl.text];
        
        
        long accType = 0;
        
        if ([_tutor accountType] == 0) {
            accType = (long)[self.accountTypePicker selectedRowInComponent:0];
        }
        else{
            accType = (long)[self.accountTypePicker selectedRowInComponent:0];
            accType++;
        }
        
        NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=tutor&id=%li&name=%@&phone=%@&clientid=%li&username=%@&accounttype=%li&password=%@&ts=%f", [_tutor tutorID], [_tutor name], [_tutor phone], [[session client] clientID], username, accType, self.passwordTextField.text, [[NSDate date] timeIntervalSince1970]];
    
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
        
        //NSLog(@"%@", urlString);
        
        
        NSURL *url = [NSURL URLWithString: urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    else{
        self.statusLbl.text = @"please enter a name and password!";
        self.statusLbl.hidden = NO;
    }
}

-(void)delete{
    [Tools showLoader];
    
    [_tutor setName:self.nameTextField.text];
    [_tutor setPhone:self.phoneTextField.text];
    
    self.statusLbl.hidden = YES;
    
    //http://localhost:59838/mobileapp/save_data.aspx?datatype=student&id=29&name=hellofromquery2
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=tutor&id=%li&delete=1&clientid=%li&ts=%f", [_tutor tutorID], [[session client] clientID], [[NSDate date] timeIntervalSince1970]];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
    
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
    _saveResultArray = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"1"])
    {
        if ([Tools isIpad]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        else{
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }

    }
    else if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"2"])
    {
        self.statusLbl.text = @"Username taken";
        self.statusLbl.hidden = NO;
        //self.toSlotBtn.hidden = NO;
    }
    
    else if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"3"])
    {
        if ([Tools isIpad]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        else{
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
        
    }
    else{
        self.statusLbl.text = @"Error with saving";
        self.statusLbl.hidden = NO;
    }
}



-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [Tools hideLoader];
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    return [_ComponentsArray count];

}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_ComponentsArray objectAtIndex:row];
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
