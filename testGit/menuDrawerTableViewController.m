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

-(void)viewDidAppear:(BOOL)animated{
    _indexPath = nil;
}

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue { }

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"742-wrench-selected.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _cellsArray = [[NSMutableArray alloc] init];
    NSMutableArray *section =[[NSMutableArray alloc ]init];
    
    //SECTION
    NSArray *cell = [[NSArray alloc]initWithObjects:@"clock_80.png", @"Slots", @"", @"slots", nil];
    [section addObject:cell];
    
//    cell = [[NSArray alloc]initWithObjects:@"Calendar-Date-03-80.png", @"Calender", @"", @"calender", nil];
//    [section addObject:cell];
    cell = [[NSArray alloc]initWithObjects:@"people_80.png", @"Courses", @"", @"courses", nil];
    [section addObject:cell];

    
    cell = [[NSArray alloc]initWithObjects:@"add_80.png", @"Add lessons", @"", @"addlessons", nil];
    [section addObject:cell];

    [_cellsArray addObject:section];
    
    //SECTION
    section =[[NSMutableArray alloc ]init];
    cell = [[NSArray alloc]initWithObjects:@"people_80.png", @"Tutors", @"", @"tutors", nil];
    [section addObject:cell];
    
    cell = [[NSArray alloc]initWithObjects:@"people_80.png", @"Courses", @"", @"allcourses", nil];
    [section addObject:cell];
    cell = [[NSArray alloc]initWithObjects:@"people_80.png", @"Students", @"", @"students", nil];
    [section addObject:cell];
    [_cellsArray addObject:section];
    
    //SECTION
    section =[[NSMutableArray alloc ]init];
    cell = [[NSArray alloc]initWithObjects:@"602-exit.png", @"Logout", @"", @"logout", nil];
    [section addObject:cell];
    [_cellsArray addObject:section];
    
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
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


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
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
    
    //[[cell contentView] setBackgroundColor:[UIColor clearColor]];
    //[[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
    //[cell setBackgroundColor:[UIColor clearColor]];
    
    //cell.textLabel.textColor = [UIColor whiteColor];
    //cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    cell.accessibilityValue = [[[_cellsArray objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] objectAtIndex: 3];
    
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
    if((indexPath.row == 4 && indexPath.section == 0) ||
       (indexPath.row == 3 && indexPath.section == 0)){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // slots
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if([cell.accessibilityValue isEqualToString:@"slots"] ){
        UINavigationController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"lessonSlots"];
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        calenderViewController *calView = (calenderViewController *)controller.topViewController;
        calView.menuDrawerDelegate = (id)self;
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    // CALENDER
    if([cell.accessibilityValue isEqualToString:@"calender"]){
        //[self.detailViewController.navigationController popToViewController:[self.detailViewController.navigationController.viewControllers objectAtIndex:0] animated:NO];
        
        // VERSION 1
//        self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
//        //[controller performSegueWithIdentifier: @"toAgendaFromSplit" sender: controller];
//        
//        DetailViewController *controller = self.detailViewController;
//        [controller changed];
//        
//        calenderViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"calenderView"];
//        view.splitViewController.delegate = view;
//        view.accessibilityValue = @"calenderView";
//        [controller.navigationController pushViewController:view animated:NO];
        
        
        
        
        /// VERSION 2
//        [session setShouldHideMasterInLandscape:YES];
//        
//        DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
//        
//        UINavigationController <SubstitutableDetailViewController> *detailViewController = nil;
//        
        UINavigationController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"calenderView"];
        calenderViewController *calView = (calenderViewController *)controller.topViewController;
        calView.menuDrawerDelegate = (id)self;
        //indexViewController *top = [self.storyboard instantiateViewControllerWithIdentifier:@"calenderView"];
        //Object *obj = [[Object alloc] init];
        //[obj setStr:@"hello123"];
        controller.topViewController.accessibilityValue = @"calenderView";
        
        //NSArray *viewControllers = [[NSArray alloc] initWithObjects:detailViewController, top, nil];
        //detailViewManager.viewControllers = viewControllers;
        //[self presentViewController:top animated:YES];
        // - [self presentViewController:controller animated:YES completion:nil];
        //[controller]
        
        
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
        
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        [self presentViewController:controller animated:YES completion:nil];
        
        // it is important to do this after presentModalViewController:animated:
        //controller.view.superview.bounds = CGRectMake(0, 0, 600, 600);
        //controller.view.superview.center = CGPointMake(roundf(self.view.center.x), roundf(self.view.center.y));
        //detailViewManager.detailViewController = detailViewController;

    }
    
    
    if([cell.accessibilityValue isEqualToString:@"addlessons"]){
        _indexPath= indexPath;
        addLessonsTableViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"addLessonsTableView"];
        [self.navigationController pushViewController:view animated:YES];
    }
    
    //logout
    if([cell.accessibilityValue isEqualToString:@"logout"]){
        _indexPath= indexPath;
        //session = [[Session alloc] init];
        
        //[self.detailViewController.navigationController popToViewController:[self.detailViewController.navigationController.viewControllers objectAtIndex:0] animated:NO];
        self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
        
        DetailViewController *controller = self.detailViewController;
        //[controller changed];
        
        loginViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        
        view.tabBar = self.tabBarController;
        view.hasJustLoggedOut = YES;
        
        [controller.navigationController presentViewController:view animated:NO completion:nil];
        
        
        [self.detailViewController.navigationController popToViewController:[self.detailViewController.navigationController.viewControllers objectAtIndex:0] animated:NO];
        
        DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
        
        UINavigationController <SubstitutableDetailViewController> *detailViewController = nil;
        
        detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailNavigationController"];
        
        AddLessonsViewController *top = [self.storyboard instantiateViewControllerWithIdentifier:@"dayView"];
        [detailViewController pushViewController:top animated:YES];
        detailViewManager.detailViewController = detailViewController;
        
    }
    
    if([cell.accessibilityValue isEqualToString:@"people"]){
        _indexPath= indexPath;
        addLessonsTableViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"PeopleTableView"];
        [self.navigationController pushViewController:view animated:YES];

    }
    
    //TUTORS
    if([cell.accessibilityValue isEqualToString:@"tutors"]){
        _indexPath= indexPath;
        [self.detailViewController.navigationController popToViewController:[self.detailViewController.navigationController.viewControllers objectAtIndex:0] animated:NO];
        
        DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
        
        UINavigationController <SubstitutableDetailViewController> *detailViewController = nil;
                
        detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailNavigationController"];
        
        AddLessonsViewController *top = [self.storyboard instantiateViewControllerWithIdentifier:@"editTutorsTableView"];
        [detailViewController pushViewController:top animated:YES];
        detailViewManager.detailViewController = detailViewController;
        
    }

    //COURSES
    if([cell.accessibilityValue isEqualToString:@"courses"]){
        _indexPath= indexPath;
        [self.detailViewController.navigationController popToViewController:[self.detailViewController.navigationController.viewControllers objectAtIndex:0] animated:NO];
        
        DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
        
        UINavigationController <SubstitutableDetailViewController> *detailViewController = nil;
        
        detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailNavigationController"];
        
        editCoursesTableViewController *top = [self.storyboard instantiateViewControllerWithIdentifier:@"editCourses"];
        top.tutor = [session tutor];
    
        [detailViewController pushViewController:top animated:YES];
        detailViewManager.detailViewController = detailViewController;
        
    }
    
    if([cell.accessibilityValue isEqualToString:@"allcourses"]){
        _indexPath= indexPath;
        [self.detailViewController.navigationController popToViewController:[self.detailViewController.navigationController.viewControllers objectAtIndex:0] animated:NO];
        
        DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
        
        UINavigationController <SubstitutableDetailViewController> *detailViewController = nil;
        
        detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailNavigationController"];
        
        clientCoursesTableViewController *top = [self.storyboard instantiateViewControllerWithIdentifier:@"clientCourses"];
        
        [detailViewController pushViewController:top animated:YES];
        detailViewManager.detailViewController = detailViewController;
        
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
        sectionName = [NSString stringWithFormat:@"Your controls (%@)", [[session tutor] name]];
    }
    else if(section == 1){
        sectionName = [NSString stringWithFormat:@"Client controls (%@)", [[session client] name]];
    }
    return sectionName;
}

-(void)deselectTableRow
{
    NSIndexPath *indexPath= [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView selectRowAtIndexPath:_indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70, 50, self.tableView.bounds.size.width, 0.01f)];
//    //[view setBackgroundColor:[Tools colorFromHexString:@"#004c6d"]];
//    [view setBackgroundColor:[UIColor clearColor]];
//    
//    UILabel *myLabel = [[UILabel alloc] init];
//    myLabel.frame = CGRectMake(20, 23, 320, 20);
//    myLabel.font = [UIFont boldSystemFontOfSize:17];
//    myLabel.textColor = [UIColor whiteColor];
//    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
//    
//    [view addSubview:myLabel];
//    
//    return view;
//}


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
