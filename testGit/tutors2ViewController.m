//
//  tutors2ViewController.m
//  testGit
//
//  Created by Alex Bechmann on 24/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "tutors2ViewController.h"
#import "coursesViewController.h"
#import "saveTutorViewController.h"
#import "editTutorsListViewController.h"
#import "Tools.h"

@interface tutors2ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end


@implementation tutors2ViewController

- (void)menuViewControllerDidFinishWithMenuItemID:(NSInteger)menuItemID
{
     [self.slidingViewController resetTopView];
}

- (void)viewDidAppear:(BOOL)animated {
    [Tools showLoader];
    //[_mainTableView triggerPullToRefresh];
    //
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=tutorsbyclient&id=%d&ts=%f", 1, [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    // Add a shadow to the top view so it looks like it is on top of the others
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    // Tell it which view should be created under left
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
        //[(MenuViewController *)self.slidingViewController.underLeftViewController setCategoryList:self.toDoCategories];
        [(MenuViewController *)self.slidingViewController.underLeftViewController setDelegate:self];
    }
    
    [Tools showLoader];
    //[_mainTableView triggerPullToRefresh];
    _data = [[NSMutableData alloc]init];
    _tutors = [[NSArray alloc] init];
    [_mainTableView reloadData];
    
    _statusLbl.hidden = YES;
    
    // Add the pan gesture to allow sliding
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    // Unselect the selected row if any
    NSIndexPath*    selection = [self.mainTableView indexPathForSelectedRow];
    if (selection) {
        [self.mainTableView deselectRowAtIndexPath:selection animated:YES];
    }
    
    UIColor *barColor = [Tools colorFromHexString:@"#b44444"];
    self.navigationController.navigationBar.barTintColor = barColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;

    UIBarButtonItem *plusBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plus)];
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:plusBtn, editBtn, nil]];

    [_mainTableView addPullToRefreshWithActionHandler:^{
        //[Tools showLoader];
        //[_mainTableView triggerPullToRefresh];
        //
        NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=tutorsbyclient&id=%d&ts=%f", 1, [[NSDate date] timeIntervalSince1970]];
        NSURL *url = [NSURL URLWithString: urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }];
    
    UIColor *barColor = [Tools colorFromHexString:@"#b44444"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.barTintColor = barColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}

-(void)plus{
    _tutorSender = [[Tutor alloc] init];
    saveTutorViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"saveTutor"];
    view.tutor = _tutorSender;
    [self.navigationController pushViewController:view animated:YES];
    
}

-(void)edit{
    editTutorsListViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"editTutorsList"];
    [self.navigationController pushViewController:view animated:YES];
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
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                          reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [[_tutors objectAtIndex:indexPath.row] objectForKey:@"TutorName"];
    cell.accessibilityValue = [[_tutors objectAtIndex:indexPath.row] objectForKey:@"TutorID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //onclick for each object, put to label for example
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.tutorIDSender = cell.accessibilityValue;
    self.tutorNameSender = cell.textLabel.text;
    //[self performSegueWithIdentifier:@"TutorsToCourses" sender:self];
    
    _tutorSender = [[Tutor alloc] init];
    [_tutorSender setTutorID:[cell.accessibilityValue intValue]];
    [_tutorSender setName:cell.textLabel.text];
    
    coursesViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"courses"];
    view.tutorID = self.tutorIDSender;
    view.tutorName = self.tutorNameSender;
    view.tutor = _tutorSender;
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
    [_mainTableView.pullToRefreshView stopAnimating];
    [Tools hideLoader];

    _tutors = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    [self.mainTableView reloadData];
    
    if ([_tutors count] == 0) {
        _statusLbl.hidden = NO;
        _statusLbl.text = @"No tutors, click the plus to add one";
        [_mainTableView setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        _statusLbl.hidden = YES;
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [Tools hideLoader];
    [_mainTableView.pullToRefreshView stopAnimating];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    coursesViewController *item = segue.destinationViewController;
//    item.tutorID = self.tutorIDSender;
//    item.tutorName = self.tutorNameSender;
}





@end
