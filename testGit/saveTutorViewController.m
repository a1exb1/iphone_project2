//
//  saveTutorViewController.m
//  testGit
//
//  Created by Alex Bechmann on 02/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "saveTutorViewController.h"

@interface saveTutorViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

@implementation saveTutorViewController

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
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    if([_tutor tutorID] > 0){
        UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(authorizeDelete)];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveBtn, deleteBtn, nil]];
    }
    else{
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveBtn, nil]];
    }
    
    
    
    self.nameTextField.text = [_tutor name];
    self.phoneTextField.text = [_tutor phone];
    
    if([_tutor tutorID] == 0){
        self.title = @"Create tutor";
    }
    else{
        self.title = @"Edit tutor";
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
                                          otherButtonTitles:@"Delete tutor", nil];
    [alert show];
}

-(void)save{
    if (self.nameTextField.text && self.nameTextField.text.length > 0) {
        
        [_tutor setName:self.nameTextField.text];
        [_tutor setPhone:self.phoneTextField.text];
    
        self.statusLbl.hidden = YES;
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=tutor&id=%li&name=%@&phone=%@&clientid=%i&ts=%f", [_tutor tutorID], [_tutor name], [_tutor phone], 1, [[NSDate date] timeIntervalSince1970]];
    
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
    [_tutor setName:self.nameTextField.text];
    [_tutor setPhone:self.phoneTextField.text];
    
    self.statusLbl.hidden = YES;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //http://localhost:59838/mobileapp/save_data.aspx?datatype=student&id=29&name=hellofromquery2
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/save_data.aspx?datatype=tutor&id=%li&delete=1&clientid=%i&ts=%f", [_tutor tutorID], 1, [[NSDate date] timeIntervalSince1970]];
    
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    _saveResultArray = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"1"])
    {
        //[self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];

    }
    else if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"2"])
    {
        self.statusLbl.text = @"Error with saving";
        self.statusLbl.hidden = NO;
        //self.toSlotBtn.hidden = NO;
    }
    
    else if([[[_saveResultArray objectAtIndex:0] objectForKey:@"success" ] isEqualToString:@"3"])
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
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
