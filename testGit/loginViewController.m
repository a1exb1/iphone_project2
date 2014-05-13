//
//  loginViewController.m
//  testGit
//
//  Created by Thomas Kjær Christensen on 12/05/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "loginViewController.h"


@interface loginViewController ()

@end

@implementation loginViewController

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
    
   
    _bgImg.image = [UIImage imageNamed:@"login_portrait.jpg"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)login:(id)sender{
    self.statusLbl.hidden = YES;
    
    if(self.usernameTextField.text.length > 0 && self.passwordTextField.text.length > 0){
        [self jsonRequestGetData];
    }
    else{
//        self.statusLbl.hidden = NO;
//        _statusLbl.text = @"Please enter your login details!";
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your username and password!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorView show];
    }
    
}

-(void)jsonRequestGetData
{
    //[Tools showLoader];
    
     _clientArray = [[NSArray alloc] init];
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
  
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=login&id=%@&username=%@&password=%@&ts=%f", username, username, password, [[NSDate date] timeIntervalSince1970]];
    
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
    //[Tools hideLoader];
    
    _clientArray = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    if ([_clientArray count] == 0) {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorView show];
        //self.statusLbl.hidden = NO;
        //NSLog(@"Connection error!");
    }
    else{
        if([[[_clientArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1" ]){
            //NSLog(@"login success");
            
            [[session client] setClientID:[[[_clientArray objectAtIndex:0] objectForKey:@"clientid"] intValue]];
            [[session client] setPremium:[[[_clientArray objectAtIndex:0] objectForKey:@"success"] intValue]];
            
            [self loginSuccess];
        }
        else{
//            self.statusLbl.hidden = NO;
//            NSLog(@"Incorrect login details!");
            UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect username or password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorView show];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    //[Tools hideLoader];
}

-(void) loginSuccess{
    //[Tools hideLoader];
    
    UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];

    [self presentViewController:view animated:YES completion:nil];
}

@end
