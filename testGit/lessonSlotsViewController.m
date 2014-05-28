//
//  lessonSlotsViewController.m
//  PlanIt!
//
//  Created by Alex Bechmann on 27/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "lessonSlotsViewController.h"

@interface lessonSlotsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

@implementation lessonSlotsViewController

extern Session *session;

NSTimer *timer;

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
    
    [[session client] setClientID:1];
    [[session client] setPremium:0];
    [[session client] setClientUserName:@"Test"];
    [[session tutor] setTutorID:3];
    [[session tutor] setAccountType:0];
    
    [Tools addECSlidingDefaultSetupWithViewController:self];
    self.webView.delegate = self;
    
    self.title = @"Lesson slots";
    
    [self showNavigationBar];

}

-(void)showNavigationBar
{
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:refreshBtn, nil]];
}

-(void)hideNavigationBar
{
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:nil, nil]];
}

-(void)loadUrl
{
    self.statusLbl.hidden = YES;
    self.webView.hidden = YES;
    
    [Tools showLightLoader];
    [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:nil andTint:nil theme:@"light"];
    
    NSString *fullURL = [NSString stringWithFormat: @"http://lm.bechmann.co.uk/sections/frames/lesson_slots.aspx?from=defaultlessontimes&tp=tutor&tutorid=%li&clientid=%li&auth=0CCAAC112", [[session tutor] tutorID], [[session client] clientID]];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self loadUrl];
}

-(void)refresh
{
    [self loadUrl];
}

- (void)cancelWeb
{
    //NSLog(@"didn't finish loading within 20 sec");
    //[Tools hideLoader];
    //self.webView.hidden = NO;
    // do anything error
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
    [Tools hideLoader];
    [self showNavigationBar];
    self.statusLbl.hidden = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // webView connected
    //timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Tools hideLoader];
    self.webView.hidden = NO;
    [timer invalidate];
    [self showNavigationBar];
    
}

- (void)viewDidLayoutSubviews {
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0);
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
