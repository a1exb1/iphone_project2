//
//  viewAllStudentsViewController.m
//  testGit
//
//  Created by Alex Bechmann on 30/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "viewAllStudentsViewController.h"
#import "editLessonSlotViewController.h"
#import "Tools.h"

@interface viewAllStudentsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

int goToSlots = 0;

@implementation viewAllStudentsViewController

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
    
    _data = [[NSMutableData alloc]init];
    _students = [[NSArray alloc] init];
    [_mainTableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [Tools showLoader];
    
    NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=studentsbytutor&id=%li&ts=%f", [[_studentCourseLink tutor] tutorID], [[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    Course *previousCourse = [_studentCourseLink course];
    //[_studentCourseLink setStudent: [[Student alloc]init]];
    
    _studentCourseLinkSender = [[StudentCourseLink alloc]init];
    [_studentCourseLinkSender setStudent:[[Student alloc] init]];
    
    [_studentCourseLinkSender setCourse:previousCourse];
    //[_student setStudentCourseLink:studentCourseLink];
    goToSlots = 0;
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    [_mainTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [Tools showLoader];
    
    [_mainTableView addPullToRefreshWithActionHandler:^{
        NSString *urlString = [NSString stringWithFormat:@"http://lm.bechmann.co.uk/mobileapp/get_data.aspx?datatype=studentsbytutor&id=%li&ts=%f", [[_studentCourseLink tutor] tutorID], [[NSDate date] timeIntervalSince1970]];
        NSURL *url = [NSURL URLWithString: urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [_students count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [[_students objectAtIndex:indexPath.row] objectForKey:@"StudentName"];
    cell.accessibilityValue = [[_students objectAtIndex:indexPath.row] objectForKey:@"StudentID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //onclick for each object, put to label for example
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [_studentCourseLinkSender setStudent:[[Student alloc] init]];
    [[_studentCourseLinkSender student] setStudentID:[cell.accessibilityValue intValue]];
    [[_studentCourseLinkSender student] setName:cell.textLabel.text];
    
    //StudentCourseLink *studentCourseLink = [[StudentCourseLink alloc]init];
    //[studentCourseLink setCourseID:cID];
    Course *previousCourse = [_studentCourseLink course];
    [_studentCourseLink setCourse:previousCourse];
    goToSlots = 1;
    [self performSegueWithIdentifier:@"AllStudentsToSlot" sender:self];
    
    
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
    [_mainTableView.pullToRefreshView stopAnimating];
    _students = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    [self.mainTableView reloadData];
    
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
    
    editLessonSlotViewController *item = segue.destinationViewController;
//    item.tutorID = self.tutorIDSender;
//    item.tutorName = self.tutorNameSender;
    
    //NSLog(@"%@", [_student name]);
    if (goToSlots == 1) {
        item.popViews = 2;
    }
    //
    item.studentCourseLink = _studentCourseLinkSender;
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
