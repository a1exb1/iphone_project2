//
//  editTutorsListViewController.m
//  testGit
//
//  Created by Alex Bechmann on 03/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "editTutorsListViewController.h"
#import "saveTutorViewController.h"
#import "Tools.h"


@interface editTutorsListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation editTutorsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [Tools showLoader];
}

- (void)viewDidAppear:(BOOL)animated {
    [Tools showLoader];
    //
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=tutorsbyclient&id=%d&ts=%f", 1, [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
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
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.title = @"Edit a tutor";
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor groupTableViewBackgroundColor]];
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
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
    cell.detailTextLabel.text = @"Edit the tutor's details";
    return cell;
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
    
    _tutors = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    [self.mainTableView reloadData];
    
    if ([_tutors count] == 0) {
        //_statusLbl.text = @"No tutors, click the plus to add one";
        [_mainTableView setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        //_statusLbl.hidden = YES;
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Data download failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
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
