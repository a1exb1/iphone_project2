//
//  loginViewController.m
//  testGit
//
//  Created by Thomas Kjær Christensen on 12/05/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "loginViewController.h"


@interface loginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


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
    
    
    
    //_bgImg.image = [UIImage imageNamed:@"login_portrait.jpg"];
    
    //_bgImg.image = [UIImage imageNamed:@"SplashScreenLogin2.png"];
    
    [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:nil andTint:nil theme:@"dark"];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    _bgImg.clipsToBounds = YES;
    _bgImg.contentMode = UIViewContentModeScaleAspectFit;
    
    //PLIST GET
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to the data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"mydata.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, get property list from main bundle
        plistPath = [[ NSBundle mainBundle] pathForResource:@"loginPlist" ofType:@"plist"];
    }
    
    
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    // convert plist into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML
                                                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!temp)
    {
        NSLog(@"error reading plist: %@, format: %lu", errorDesc, format);
    }
    else{
        self.usernameTextField.text = [temp objectForKey:@"username"];
        self.passwordTextField.text = [temp objectForKey:@"password"];
        if(!_hasJustLoggedOut){
            [self loginCheck];
        }
        
    }
    
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    _bgImg.frame= CGRectMake(0.0f, 0.0f, self.view.frame.size.width, _bgImg.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginCheck
{
    //self.statusLbl.hidden = YES;
    //self.usernameTextField.hidden = YES;
    //self.passwordTextField.hidden = YES;
    
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

-(IBAction)login:(id)sender{
    [self loginCheck];
    
}

-(void)jsonRequestGetData
{
    [Tools showLoader];
    self.loginBtn.hidden = YES;
    self.usernameTextField.hidden = YES;
    self.passwordTextField.hidden = YES;
    
    _clientArray = [[NSArray alloc] init];
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=login&id=0&username=%@&password=%@&ts=%f", username, password, [[NSDate date] timeIntervalSince1970]];
    
    //NSLog(@"%@", urlString);
    
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
    
    NSLog(@"%@", _clientArray);
    
    if ([_clientArray count] == 0) {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorView show];
        self.loginBtn.hidden = NO;
        self.usernameTextField.hidden = NO;
        self.passwordTextField.hidden = NO;
        //self.statusLbl.hidden = NO;
        //NSLog(@"Connection error!");
    }
    else{
        if([[[_clientArray objectAtIndex:0] objectForKey:@"success"] isEqualToString:@"1" ]){
            //NSLog(@"login success");
            
            session = [[Session alloc] init];
            [session setTutor: [[Tutor alloc] init]];
            [session setClient: [[Client alloc] init]];
            
            [[session client] setClientID:[[[_clientArray objectAtIndex:0] objectForKey:@"clientid"] intValue]];
            [[session client] setPremium:[[[_clientArray objectAtIndex:0] objectForKey:@"clientaccounttype"] intValue]];
            [[session client] setClientUserName:[[_clientArray objectAtIndex:0] objectForKey:@"clientusername"]];
            [[session tutor] setTutorID:[[[_clientArray objectAtIndex:0] objectForKey:@"tutorid"] intValue]];
            [[session tutor] setAccountType:[[[_clientArray objectAtIndex:0] objectForKey:@"tutoraccounttype"] intValue]];
            
            [self loginSuccess];
        }
        else{
            UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect username or password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorView show];
            self.loginBtn.hidden = NO;
            self.usernameTextField.hidden = NO;
            self.passwordTextField.hidden = NO;
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [Tools hideLoader];
    self.loginBtn.hidden = NO;
    self.usernameTextField.hidden = NO;
    self.passwordTextField.hidden = NO;
}

-(void) loginSuccess{
    [Tools hideLoader];
    
    //SAVE TO PLIST
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to the data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"mydata.plist"];
    
    
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: self.usernameTextField.text,
                          self.passwordTextField.text, nil]
                          forKeys:[NSArray arrayWithObjects: @"username", @"password", nil]];
    NSString *error = nil;
    
    // create NSData from dictionary object
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // check if plistData exists 
    if(plistData) 
    { 
        // write plistData to myData.plist file 
        [plistData writeToFile:plistPath atomically:YES]; 
    } 
    else 
    { 
        NSLog(@"saving data imploded - error: %@", error); 
        
    }
    
    // END SAVE PLIST
    
    
    if ( [Tools isIpad] )
    {
        _tabBar.selectedIndex = 0;
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else
    {
        UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
        
        [self presentViewController:view animated:YES completion:nil];
    }
}

@end
