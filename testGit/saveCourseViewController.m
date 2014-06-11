//
//  saveCourseViewController.m
//  testGit
//
//  Created by Alex Bechmann on 03/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "saveCourseViewController.h"
#import "Tools.h"
#import "Session.h"

@interface saveCourseViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

@implementation saveCourseViewController

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
    if(![Tools isIpad]){
        [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:[Tools colorFromHexString:@"#57AD2C"] andTint:[UIColor whiteColor] theme:@"dark"];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    if([_course courseID] > 0) {
        UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(authorizeDelete)];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveBtn, deleteBtn, nil]];
    }
    else{
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveBtn, nil]];
    }
    
    self.navigationItem.title = @"Back";
    self.nameTextField.text = [_course name];
    //self.phoneTextField.text = [_course phone];
    
    if([_course courseID] == 0){
        self.title = @"Create course";
    }
    else{
        self.title = @"Edit course";
    }
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
                                          otherButtonTitles:@"Delete course", nil];
    [alert show];
}

-(void)save{
    if (self.nameTextField.text && self.nameTextField.text.length > 0) {
        
        [_course setName:self.nameTextField.text];
        self.statusLbl.hidden = YES;
    
        [Tools showLoader];
        NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=course&id=%li&name=%@&tutorid=%li&clientid=%li&ts=%f", [_course courseID], [_course name], [_tutor tutorID], [[session client] clientID], [[NSDate date] timeIntervalSince1970]];
    
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:
                 NSASCIIStringEncoding];
    
        NSURL *url = [NSURL URLWithString: urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    else{
        self.statusLbl.text = @"please enter a name!";
        self.statusLbl.hidden = NO;
    }
}

-(void)delete{
    [_course setName:self.nameTextField.text];
    
    self.statusLbl.hidden = YES;
    
    [Tools showLoader];
    //http://localhost:59838/mobileapp/save_data.aspx?datatype=student&id=29&name=hellofromquery2
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=course&id=%li&delete=1&clientid=%li&ts=%f", [_course courseID], [[session client] clientID], [[NSDate date] timeIntervalSince1970]];
    
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
        //[self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
    }
    else if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"2"])
    {
        self.statusLbl.text = @"Error with saving";
        self.statusLbl.hidden = NO;
        //self.toSlotBtn.hidden = NO;
    }
    
    else if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"3"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
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
