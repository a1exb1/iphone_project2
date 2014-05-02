//
//  editStudentAndSlotViewController.m
//  testGit
//
//  Created by Alex Bechmann on 29/04/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "editStudentAndSlotViewController.h"



@interface editStudentAndSlotViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end


int cellClicked = -1;


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
    
    _cells = [[NSArray alloc] initWithObjects:[[_studentCourseLink student] name], _studentCourseLink , nil];
    
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
        cell.textLabel.text = [[_studentCourseLink student] name];
        cell.detailTextLabel.text = @"Edit the student's details.";
        //cell.accessibilityValue = _student;
    }
    else if(indexPath.row == 1){
        NSString *cellHour = [NSString stringWithFormat:@"%02d", [_studentCourseLink Hour]];
        NSString *cellMins = [NSString stringWithFormat:@"%02d", [_studentCourseLink Mins]];
        NSString *cellCourse = [[_studentCourseLink course] name];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@:%@ (%i mins)", cellCourse, @"at",cellHour, cellMins, [_studentCourseLink Duration]];
        cell.detailTextLabel.text = @"Change lesson time.";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0) {
        
        cellClicked = 0;
        [self performSegueWithIdentifier:@"studentAndSlotToEditStudent" sender:self];
        
    }
    
    else if(indexPath.row == 1){
        cellClicked = 1;
        [self performSegueWithIdentifier:@"studentAndSlotToEditSlot" sender:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


-(void)updatedSlot:(StudentCourseLink *)studentCourseLink{
    _cells = [[NSArray alloc] initWithObjects:[[_studentCourseLink student] name], _studentCourseLink , nil];
    _studentCourseLink = studentCourseLink;
    [_mainTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    
    if(cellClicked == 0){
        editStudentViewController *item = segue.destinationViewController;
        item.studentCourseLink = _studentCourseLink;
        item.editStudentDelegate = self;
    }
    else if (cellClicked == 1){
        editLessonSlotViewController *item = segue.destinationViewController;
        item.studentCourseLink = _studentCourseLink;
        item.editLessonSlotDelegate = self;
        item.popViews = 3;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
