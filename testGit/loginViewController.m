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

extern Client *client;

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
    
    _clientArray = [[NSArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)login:(id)sender{

    
    [self jsonRequestGetData];
}

-(void)jsonRequestGetData
{
    [Tools showLoader];
    
    
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
  
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=login&id=%@&username=%@&password=%@&ts=%f", username, username, password, [[NSDate date] timeIntervalSince1970]];
    
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
    
    _clientArray = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    NSLog(@"yoyo%@", _clientArray);
    
    [self loginSuccess];
    
    if ([_clientArray count] == 0) {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorView show];
    }
    else{
        if([[[_clientArray objectAtIndex:0] objectForKey:@"Success"] isEqualToString:@"1" ]){
            NSLog(@"login success");
        }
        else{
            NSLog(@"login failed");
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [Tools hideLoader];
}

-(void) loginSuccess{
    NSLog(@"loginSuccess method");
    
    [client setClientID:1];
    [client setPremium:0];
    AgendaViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    
    [self.navigationController presentViewController:view animated:YES completion:nil];
    
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
