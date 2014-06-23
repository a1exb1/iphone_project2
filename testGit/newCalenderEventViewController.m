//
//  newCalenderEventViewController.m
//  PlanIt!
//
//  Created by Alex Bechmann on 23/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "newCalenderEventViewController.h"

@interface newCalenderEventViewController ()
@property (weak, nonatomic) IBOutlet UILabel *studentLbl;
@property (weak, nonatomic) IBOutlet UILabel *courseLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *lessonDatePicker;
@end

@implementation newCalenderEventViewController

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
    NSDate *today = [[NSDate alloc] init];
    [_lessonDatePicker setMinimumDate:today];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    if ([_lesson LessonID] > 0) {
        self.navigationItem.leftBarButtonItem = deleteBtn;
    }
    self.navigationController.navigationBar.translucent = NO;
    
    _studentLbl.text = [[_lesson student] name];
    _courseLbl.text = [[_lesson course] name];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(void)save
{
    
}

-(void)delete
{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    if(indexPath.row == 0){
        cell.textLabel.text = [[_lesson student] name];
        cell.detailTextLabel.text = @"Select student";
    }
    else if(indexPath.row == 1){
        cell.textLabel.text = [[_lesson course] name];
        cell.detailTextLabel.text = @"Select course";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
