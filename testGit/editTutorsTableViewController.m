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
    //[self.tableView reloadData];
    
    
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
    
    if(_loaded){
        [self getJson];
    }

    
}

- (void)viewDidAppear:(BOOL)animated {
//    if (_currentTutorID != [[session tutor] tutorID]) {
//        [self getJson];
//        _currentTutorID = [[session tutor] tutorID];
//    }
//    
    
    UIBarButtonItem *plusBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plus)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:plusBtn, nil]];
        
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(!_loaded){
        [self getJson];
        _loaded = YES;
    }
    
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
    
    [Tools showLoaderWithView:self.view];
    

    self.title = [NSString stringWithFormat:@"Tutors (%@)", [[session client]name]];
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getJson];
        
    }];
    
    if (_navigationPaneBarButtonItem)
        [self.navigationItem setLeftBarButtonItem:self.navigationPaneBarButtonItem animated:NO];
}


-(void)getJson
{
    [Tools showLightLoaderWithView:self.view];
    [[session client] loadTutorsAsyncWithDelegate:self];
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
    customTableViewCell *cell = [[customTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [[_tutors objectAtIndex:indexPath.row] objectForKey:@"TutorName"];
    cell.accessibilityValue = [[_tutors objectAtIndex:indexPath.row] objectForKey:@"TutorID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(![Tools isIpad]){
        cell.detailTextLabel.text = @"Edit the tutor's details";
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

//MARGINED TABLE VIEW
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [Tools marginedtableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(40, 0, self.view.frame.size.width -80, 50)];
    UITableViewHeaderFooterView *sectionView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, container.frame.size.width, 50)];
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(65, 12, sectionView.frame.size.width, 50)];
    sectionHeader.text = [[self tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section] uppercaseString];
    [sectionHeader setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:13]];
    [sectionHeader setTextColor:[UIColor grayColor]];
    [sectionView addSubview:sectionHeader];
    [container addSubview:sectionView];
    
    return container;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

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




- (void) finished:(NSString *)status withArray:(NSArray *)array;
{
    _tutors = array;
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView reloadData];
    [Tools hideLoaderFromView:self.view];
    
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
