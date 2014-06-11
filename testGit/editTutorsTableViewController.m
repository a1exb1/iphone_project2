//
//  editTutorsTableViewController.m
//  PlanIt!
//
//  Created by Alex Bechmann on 10/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "editTutorsTableViewController.h"

@interface editTutorsTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

@implementation editTutorsTableViewController

extern Session *session;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    _data = [[NSMutableData alloc]init];
    _tutors = [[NSArray alloc] init];
    [self.tableView reloadData];
    
    [Tools showLoader];
    //
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=tutorsbyclient&id=%ld&ts=%f", [[session client] clientID], [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    if (![Tools isIpad]) {
        [Tools setNavigationHeaderColorWithNavigationController: self.navigationController andTabBar: self.tabBarController.tabBar andBackground:[Tools colorFromHexString:@"#b44444"] andTint:[UIColor whiteColor] theme:@"dark"];
    }
    else{
        [self.navigationItem setHidesBackButton:YES];
    }
    
    //self.tableView.bounds = CGRectInset(self.tableView.bounds, 5, 5);
    self.tableView = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    

    
}

- (void)viewDidAppear:(BOOL)animated {
    [self getJson];
    
    UIBarButtonItem *plusBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plus)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:plusBtn, nil]];
    
}

-(void)plus{
    _tutorSender = [[Tutor alloc] init];
    saveTutorViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"saveTutor"];
    view.tutor = _tutorSender;
    [self.navigationController pushViewController:view animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Tools showLoader];
    

    self.title = @"Edit a tutor";
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=tutorsbyclient&id=%ld&ts=%f", [[session client] clientID], [[NSDate date] timeIntervalSince1970]];
        NSURL *url = [NSURL URLWithString: urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
        
    }];
    
    if (_navigationPaneBarButtonItem)
        [self.navigationItem setLeftBarButtonItem:self.navigationPaneBarButtonItem animated:NO];
}


-(void)getJson
{
    _data = [[NSMutableData alloc]init];
    _tutors = [[NSArray alloc] init];
    [self.tableView reloadData];
    [Tools showLoader];
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=tutorsbyclient&id=%ld&ts=%f", [[session client] clientID], [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)setNavigationPaneBarButtonItem:(UIBarButtonItem *)navigationPaneBarButtonItem
{
    if (navigationPaneBarButtonItem != _navigationPaneBarButtonItem) {
        if (navigationPaneBarButtonItem)
            //[self.toolbar setItems:[NSArray arrayWithObject:navigationPaneBarButtonItem] animated:NO];
            [self.navigationItem setLeftBarButtonItem:navigationPaneBarButtonItem animated:NO];
        else
            //[self.toolbar setItems:nil animated:NO];
            [self.navigationItem setLeftBarButtonItem:nil animated:NO];
        
        //[self.navigationController.navigationItem setLeftBarButtonItem:navigationPaneBarButtonItem animated:NO];
        _navigationPaneBarButtonItem = navigationPaneBarButtonItem;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tutors count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [[_tutors objectAtIndex:indexPath.row] objectForKey:@"TutorName"];
    cell.accessibilityValue = [[_tutors objectAtIndex:indexPath.row] objectForKey:@"TutorID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(![Tools isIpad]){
        cell.detailTextLabel.text = @"Edit the tutor's details";
    }
    
    return cell;
}
//
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if ([_tutors count] == 0) {
//        return @"No tutors, click the plus to add one";
//    }
//    else{
//        return @"";
//    }
//    
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //onclick for each object, put to label for example
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //self.tutorIDSender = cell.accessibilityValue;
    //self.tutorNameSender = cell.textLabel.text;
    //[self performSegueWithIdentifier:@"TutorsToCourses" sender:self];
    
    _tutorSender = [[Tutor alloc] init];
    [_tutorSender setTutorID:[cell.accessibilityValue intValue]];
    [_tutorSender setName:cell.textLabel.text];
    [_tutorSender setAccountType:[[[_tutors objectAtIndex:indexPath.row] objectForKey:@"AccountType"] intValue]];
    [_tutorSender setUsername:[[_tutors objectAtIndex:indexPath.row] objectForKey:@"UserName"]];
    [_tutorSender setPassword:[[_tutors objectAtIndex:indexPath.row] objectForKey:@"Password"]];
    
    saveTutorViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"saveTutor"];
    view.tutor = self.tutorSender;
    [self.navigationController pushViewController:view animated:YES];
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
    [self.tableView.pullToRefreshView stopAnimating];
    
    _tutors = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    [self.tableView reloadData];
    
    NSLog(@"%@", _tutors);
    
    if ([_tutors count] == 0) {
        _statusLbl.text = @"No tutors, click the plus to add one";
        _statusLbl.hidden = NO;
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        _statusLbl.hidden = YES;
        [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [self.tableView.pullToRefreshView stopAnimating];
    [Tools hideLoader];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
