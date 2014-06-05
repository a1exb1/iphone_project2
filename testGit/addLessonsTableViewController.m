//
//  addLessonsTableViewController.m
//  PlanIt!
//
//  Created by Alex Bechmann on 04/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "addLessonsTableViewController.h"

@interface addLessonsTableViewController ()

@end

@implementation addLessonsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _cellsArray = [[NSMutableArray alloc] init];
    NSMutableArray *section =[[NSMutableArray alloc ]init];
    
    //SECTION
    NSArray *cell = [[NSArray alloc]initWithObjects:@"add_80.png", @"Add multiple lessons", @"Between two dates", nil];
    [section addObject:cell];
    
    cell = [[NSArray alloc]initWithObjects:@"add_80.png", @"Add multiple lessons", @"For one day", nil];
    [section addObject:cell];
    
    cell = [[NSArray alloc]initWithObjects:@"add_80.png", @"Add a single lesson", @"", nil];
    [section addObject:cell];
    
    
    [_cellsArray addObject:section];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_cellsArray count];
}


//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] init];
//    [view setBackgroundColor:[UIColor clearColor]];
//    return view;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[_cellsArray objectAtIndex:section ] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Configure the cell...
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    //[[cell contentView] setBackgroundColor:[UIColor clearColor]];
    //[[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
    //[cell setBackgroundColor:[UIColor clearColor]];
    
    //cell.textLabel.textColor = [UIColor whiteColor];
    //cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if(![[[[_cellsArray objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectAtIndex: 2] isEqualToString:@""]){
        //UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.detailTextLabel.text = [[[_cellsArray objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectAtIndex: 2];
    }

    
    cell.imageView.image = [UIImage imageNamed:[[[_cellsArray objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectAtIndex: 0]];
    
    cell.textLabel.text = [[[_cellsArray objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectAtIndex: 1];
    
    //UIView *selectionColor = [[UIView alloc] init];
    //selectionColor.backgroundColor = [Tools colorFromHexString:@"#004c6d"];
    //cell.selectedBackgroundView = selectionColor;
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
