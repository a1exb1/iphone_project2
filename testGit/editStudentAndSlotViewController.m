//
//  editStudentAndSlotViewController.m
//  testGit
//
//  Created by Alex Bechmann on 29/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "editStudentAndSlotViewController.h"
#import "editStudentViewController.h"

@interface editStudentAndSlotViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end





@implementation editStudentAndSlotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Unselect the selected row if any
    NSIndexPath*    selection = [self.mainTableView indexPathForSelectedRow];
    if (selection) {
        [self.mainTableView deselectRowAtIndexPath:selection animated:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    _cells = [[NSArray alloc] initWithObjects:[_student name], [_student studentCourseLink] , nil];
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_cells count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:@"cell"];
    
    if(indexPath.row == 0){
        cell.textLabel.text = [_student name];
        cell.detailTextLabel.text = @"Edit the student's details.";
        //cell.accessibilityValue = _student;
    }
    else if(indexPath.row == 1){
        NSString *cellHour = [NSString stringWithFormat:@"%02d", [[_student studentCourseLink] Hour]];
        NSString *cellMins = [NSString stringWithFormat:@"%02d", [[_student studentCourseLink] Mins]];
        NSString *cellCourse = [[_student studentCourseLink] Course];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@:%@", cellCourse, @"at",cellHour, cellMins];
        cell.detailTextLabel.text = @"Change lesson time.";
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //onclick for each object, put to label for example
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //self.courseIDSender = cell.accessibilityValue;
    
    if(indexPath.row == 0) {
        //self.studentSender = _student;
        [self performSegueWithIdentifier:@"studentAndSlotToEditStudent" sender:self];
    }
    
    else if(indexPath.row == 1){
        [self performSegueWithIdentifier:@"studentAndSlotToEditSlot" sender:self];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *sectionName = [NSString stringWithFormat:@"%@", _tutorName];
//
//
//    return sectionName;
//}

-(void)updatedStudent:(Student *)student{
    _cells = [[NSArray alloc] initWithObjects:[_student name], [_student studentCourseLink] , nil];
    self.student = student;
    [_mainTableView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    editStudentViewController *item = segue.destinationViewController;
    item.student = self.student;
    
    item.editStudentDelegate = self;
    
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
