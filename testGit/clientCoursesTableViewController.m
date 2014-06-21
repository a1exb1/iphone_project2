//
//  clientCoursesTableViewController.m
//  PlanIt!
//
//  Created by Alex Bechmann on 20/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "clientCoursesTableViewController.h"

@interface clientCoursesTableViewController ()

@end

@implementation clientCoursesTableViewController

extern Session *session;

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
    
    //[self.tableView reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [[session client] setCourses:[[NSArray alloc] init]];
    [self.tableView reloadData];
    [Tools showLightLoaderWithView:self.view];
    [[session client] loadCoursesAsyncWithDelegate:self];
    [self.navigationItem setHidesBackButton:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    NSDictionary *tutor = [[[session client] courses] objectAtIndex:indexPath.section];
    NSArray *courses = [tutor objectForKey:@"courses"];
    NSArray *course = [courses objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = [course objectAtIndex:1];
//    
//    cell.textLabel.text = [course objectAtIndex:1];
//    cell.accessibilityValue = [course objectAtIndex:0];
    
    return cell;
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
    return [[[session client] courses]count];
    //return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *tutor = [[[session client] courses] objectAtIndex:section];
    NSArray *courses = [tutor objectForKey:@"courses"];
    //return [[tutor objectForKey:@"courses"] count];
    return [courses count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *tutor = [[[session client] courses] objectAtIndex:section];
    NSString *status = @"";
    NSArray *courses = [tutor objectForKey:@"courses"];
    if ([courses count] == 0) {
        status = @"(No courses)";
    }
    return [NSString stringWithFormat:@"%@ %@", [tutor objectForKey:@"tutorname"], status];
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

- (void) finished:(NSString *)status withArray:(NSArray *)array;
{
    [[session client] setCourses:array];
    [self.tableView reloadData];
    [Tools hideLoaderFromView:self.view];
}

@end
