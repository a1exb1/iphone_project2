//
//  menuDrawerTableViewController.m
//  PlanIt!
//
//  Created by Alex Bechmann on 27/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "menuDrawerTableViewController.h"

@interface menuDrawerTableViewController ()

@end

@implementation menuDrawerTableViewController

extern Session *session;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue { }

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
    NSArray *cell = [[NSArray alloc]initWithObjects:@"clock_80.png", @"Agenda", @"", nil];
    [section addObject:cell];
    
    cell = [[NSArray alloc]initWithObjects:@"Calendar-Date-03-80.png", @"Calender", @"", nil];
    [section addObject:cell];

    [_cellsArray addObject:section];
    
    //SECTION
    section =[[NSMutableArray alloc ]init];
    cell = [[NSArray alloc]initWithObjects:@"people_80.png", @"People", @"", nil];
    [section addObject:cell];
    
    cell = [[NSArray alloc]initWithObjects:@"User-Time80(2).png", @"Lesson slots", @"", nil];
    [section addObject:cell];
    
    cell = [[NSArray alloc]initWithObjects:@"add_80.png", @"Add multiple lessons", @"between selected dates", nil];
    [section addObject:cell];
    
    cell = [[NSArray alloc]initWithObjects:@"minus_80_black.png", @"Clear lessons", @"between selected dates", nil];
    [section addObject:cell];
    [_cellsArray addObject:section];
    
    section =[[NSMutableArray alloc ]init];

    cell = [[NSArray alloc]initWithObjects:@"logout_80.png", @"Logout", @"", nil];
    [section addObject:cell];
    [_cellsArray addObject:section];

    UIImage *image = [UIImage imageNamed:@"menu-background.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UITableView *tableView = self.tableView;
    tableView.backgroundView = imageView;
    tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(15,0,0,0)];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[_cellsArray objectAtIndex:section ] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Configure the cell...
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    [[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if(![[[[_cellsArray objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectAtIndex: 2] isEqualToString:@""]){
        //UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.detailTextLabel.text = [[[_cellsArray objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectAtIndex: 2];
    }
    
    cell.imageView.image = [UIImage imageNamed:[[[_cellsArray objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectAtIndex: 0]];
    
    cell.textLabel.text = [[[_cellsArray objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectAtIndex: 1];
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [Tools colorFromHexString:@"#004c6d"];
    cell.selectedBackgroundView = selectionColor;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // AGENDA
    if(indexPath.row == 0 && indexPath.section == 0){
        
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"agendaView"];
        
        __weak ECSlidingViewController *slidingController = [self slidingViewController];
        [slidingController resetTopViewAnimated:YES onComplete:^{
            [slidingController performSelector:@selector(anchorTopViewToLeftAnimated:) withObject:nil afterDelay:0.1];
        }];
    }
    
    // CALENDER
    if(indexPath.row == 1 && indexPath.section == 0){
        
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"calenderView"];
        self.slidingViewController.topViewController.accessibilityValue = @"calenderView";
        
        __weak ECSlidingViewController *slidingController = [self slidingViewController];
        [slidingController resetTopViewAnimated:YES onComplete:^{
            [slidingController performSelector:@selector(anchorTopViewToLeftAnimated:) withObject:nil afterDelay:0.1];
            
        }];
    }
    
    if(indexPath.row == 1 && indexPath.section == 1){
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LessonSlots"];
        
        self.slidingViewController.topViewController.accessibilityValue = @"lessonSlots";
        __weak ECSlidingViewController *slidingController = [self slidingViewController];
        [slidingController resetTopViewAnimated:YES onComplete:^{
            [slidingController performSelector:@selector(anchorTopViewToLeftAnimated:) withObject:nil afterDelay:0.1];
        }];
    }
    
    if(indexPath.row == 1){

    }
    
    if(indexPath.row == 2){

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
    
}
//004c6d

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    if(section == 0){
        sectionName = @"View";
    }
    else if(section == 1){
        sectionName = @"Manage";
    }
    return sectionName;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70, 50, self.tableView.bounds.size.width, 0.01f)];
    //[view setBackgroundColor:[Tools colorFromHexString:@"#004c6d"]];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 23, 320, 20);
    myLabel.font = [UIFont boldSystemFontOfSize:17];
    myLabel.textColor = [UIColor whiteColor];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    [view addSubview:myLabel];
    
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
